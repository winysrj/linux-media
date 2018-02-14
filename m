Return-path: <linux-media-owner@vger.kernel.org>
Received: from ptmx.org ([178.63.28.110]:57968 "EHLO ptmx.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030210AbeBNNSc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 08:18:32 -0500
Received: from [10.1.14.248] (vpn.streamunlimited.com [91.114.0.140])
        by ptmx.org (Postfix) with ESMTPSA id 389AD58B43
        for <linux-media@vger.kernel.org>; Wed, 14 Feb 2018 14:09:24 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Carlos Rafael Giani <dv@pseudoterminal.org>
Subject: media: v4l: alsa: Associating V4L2 and ALSA devices coming from the
 same device (a webcam for example)
Message-ID: <91c7585c-43f3-feb0-279a-5efdcb27dc7b@pseudoterminal.org>
Date: Wed, 14 Feb 2018 14:09:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have an application that allows for recording audio/video from input 
devices. I now want to add to it the ability to autodetect plugged-in 
USB webcams via udev. The problem is that audio and video are handled 
separately, by a video4linux and an ALSA device. The goal is to discover 
the ALSA device name and the Video4Linux device node that are associated 
(that is, belonging to the same camera input feed).

Surprisingly, there does not seem to be any interface in V4L2 for this, 
so I had to resort to looking at the udev properties. I came up with a 
very dirty hack that accomplishes what I want. I pasted it below.

This code relies on the ID_USB_INTERFACES property to associate the V4L2 
and ALSA devices, which may or may not be fragile. Furthermore, it 
traverses directories in /sys/ . I use libgudev here.

I now ask the mailing list if there is an easier way to do this. Note 
that I cannot rely on tools like the gst device monitor. It would also 
be preferable to not have to rely on specific udev rules, though I will 
add them if it is truly necessary.

Also, I found it difficult to get a meaningful label that I can present 
the user. The V4L2 properties produced fairly useless labels (something 
like "UVC camera (xxxx:yyyy)"). What produced the best results was the 
ID_MODEL_FROM_DATABASE - but this is a property of the ALSA devices.

So, anybody has a better idea how to accomplish this?


The hacky code:

     std::regex 
sndcard_regex(".*/sound/card[[:digit:]]+/controlC[[:digit:]]+$");
     std::regex pcmc_regex("pcmC([[:digit:]]+)D([[:digit:]]+)c");

     void process_added_device(GUdevDevice *p_added_device)
     {
         gchar const *bus_cstr = 
g_udev_device_get_property(p_added_device, "ID_BUS");
         if (g_strcmp0(bus_cstr, "usb") != 0)
             return;

         gchar const *path_cstr = 
g_udev_device_get_sysfs_path(p_added_device);
         gchar const *subsystem_cstr = 
g_udev_device_get_property(p_added_device, "SUBSYSTEM");
         gchar const *usb_interfaces_cstr = 
g_udev_device_get_property(p_added_device, "ID_USB_INTERFACES");

         std::string id = std::string("usbif_") + usb_interfaces_cstr;

         capture_device new_capture_device;
         new_capture_device.m_is_hdmi_device = false;
         new_capture_device.m_label = id; // initially use the ID as 
label, as fallback if no other label can be found
         new_capture_device.m_id = id;

         auto &id_view = m_entries.get < id_tag > ();
         auto iter = id_view.find(id);
         if (iter != id_view.end()) // check if an entry exists already; 
if so, retrieve it
         {
             new_capture_device = *iter;
             // remove the device from the boost multi-index container. 
we'll reinsert a modified version later.
             id_view.erase(iter);
         }

         if (g_strcmp0(subsystem_cstr, "video4linux") == 0)
         {
             gchar const *devnode_cstr = 
g_udev_device_get_device_file(p_added_device);
             new_capture_device.m_v4l2_device = devnode_cstr;
         }
         else if (g_strcmp0(subsystem_cstr, "sound") == 0)
         {
             gchar const *model_from_db = 
g_udev_device_get_property(p_added_device, "ID_MODEL_FROM_DATABASE");
             if (model_from_db != nullptr)
                 new_capture_device.m_label = model_from_db;

             std::smatch base_match;
             std::string path_str = path_cstr;
             if (std::regex_match(path_str, base_match, sndcard_regex)) 
// check if this sound device path is one to an ALSA control device
             {
                 boost::filesystem::path path = path_str;
                 path = path.parent_path();
                 boost::system::error_code ec;
                 boost::filesystem::directory_iterator dir_iter(path, ec);
                 if (ec)
                     return;

                 // search the parent directory for a PCM capture device
                 boost::filesystem::directory_iterator end_dir_iter;
                 for (; dir_iter != end_dir_iter; ++dir_iter)
                 {
                     std::smatch pcm_match;
                     if 
(std::regex_match(dir_iter->path().filename().string(), pcm_match, 
pcmc_regex))
                         new_capture_device.m_alsa_device = 
std::string("plughw:") + std::string(pcm_match[1]) + "," + 
std::string(pcm_match[2]);
                 }
             }
         }

         id_view.emplace(new_capture_device);
     }
