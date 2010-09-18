Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54574 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0IRSj2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 14:39:28 -0400
Received: by fxm3 with SMTP id 3so92957fxm.19
        for <linux-media@vger.kernel.org>; Sat, 18 Sep 2010 11:39:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Mw-G=rCjVkpoCCpphs-pp6Yt8hakGWaFPsVC+@mail.gmail.com>
References: <4C3070A4.6040702@redhat.com>
	<AANLkTinXb=TeSGO_6Mr6jhzaUOUZ3yZL5+oAP2GP0GG5@mail.gmail.com>
	<4C792BE1.6090001@redhat.com>
	<AANLkTik8jg1K_54dJ5nsnCydJzpwRNt-BzctwA1Spgq8@mail.gmail.com>
	<4C835BC7.5000209@redhat.com>
	<AANLkTi=Mw-G=rCjVkpoCCpphs-pp6Yt8hakGWaFPsVC+@mail.gmail.com>
Date: Sat, 18 Sep 2010 14:39:25 -0400
Message-ID: <AANLkTi=z-E6onqhR9g1j_ZncRAFovU=9Ud8KLVpRxOkB@mail.gmail.com>
Subject: Re: ibmcam (xrilink_cit) and konica webcam driver porting to gspca update
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jonathan Isom <jeisom@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Patryk Biela <patryk.biela@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Sep 13, 2010 at 2:02 PM, David Ellingsworth
<david@identd.dyndns.org> wrote:
> On Sun, Sep 5, 2010 at 4:58 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>> Hi,
>>
>> On 08/31/2010 11:43 PM, David Ellingsworth wrote:
>>>
>>> Hans,
>>>
>>> I haven't had any success with this driver as of yet. My camera is
>>> shown here: http://www.amazon.com/IBM-Net-Camera-Pro-camera/dp/B0009MH25U
>>> The part number listed on the bottom is 22P5086. It's also labeled as
>>> being an IBM Net Camera Pro.
>>
>> Ah ok, so you have the same one as I have, that model was never supported
>> by the old ibmcam driver, so I take it you never had it working with the
>> old ibmcam driver ?
>>
>>> When I plug the camera in, it is detected
>>>
>>> by the driver but it does not seem to function in this mode. Every
>>> attempt to obtain video from it using qv4l2 results in a black or
>>> green image.
>>>
>>> If I use the ibm_netcam_pro module option
>>
>> Given that is the same camera as I have using the ibm_netcam_pro module
>> option is definitely the right thing to do.
>>
>> I noticed in your lsusb -v output that you're doing this from within vmware?
>
> Correct I was using vmware workstation's usb pass through to test the camera.
>
>>
>> I think that is the cause of things not working. This camera will not
>> even work when connected through a real hub, let alone through a
>> virtual one. The only way this camera works for me is when it is
>> connected to a usb port directly on the motherboard, running Linux
>> directly on the hardware, can you please try that ?
>
> Unfortunately, I'm unable to test with real hardware at the moment. My
> laptop, which has Linux installed on it is currently out of commission
> until I can find time to repair it's power adapter. Once I get it
> fixed, I'll try to retest and we'll go from there.
>

I just tested this driver with my camera using real hardware and it
works wonderfully. Thanks for all the hard work. The only thing left
to do with this camera is to reverse engineer the compressed video
stream in order to improve the frame rate at higher resolutions.

Regards,

David Ellingsworth
