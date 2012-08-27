Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab2H0Hqw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Aug 2012 03:46:52 -0400
Message-ID: <503B2631.50807@redhat.com>
Date: Mon, 27 Aug 2012 09:48:01 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Sam Bulka <sambul7165@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Bug] gspca_zc3xx v.2.14.0 Auto Gain is OFF
References: <op.wjndk6b6w3grbt@weboffice>
In-Reply-To: <op.wjndk6b6w3grbt@weboffice>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sam,

Thanks for the detailed bug report. Unfortunately I don't have time to look into
this atm. Perhaps someone else reading the list has time to look into this ?

Regards,

Hans


On 08/26/2012 02:13 PM, Sam Bulka wrote:
> Hello,
>
> This is a bug report for gspca_zc3xx v.2.14.0 webcam driver installed as a module on ArchLinux plug computer, kernel 3.5.2-1-ARCH
>
> [root@alarm ~]# dmesg
>
> [   15.271381] gspca_main: v2.14.0 registered
> [   15.303224] gspca_main: gspca_zc3xx-2.14.0 probing 046d:08d7
> [   16.211715] fuse init (API version 7.19)
> [   16.461436] input: gspca_zc3xx as /devices/platform/orion-ehci.0/usb1/1-1/1-1.4/input/input0
> [   16.469635] usbcore: registered new interface driver snd-usb-audio
> [   16.470642] usbcore: registered new interface driver gspca_zc3xx
>
> [root@alarm ~]# lsusb
> Bus 001 Device 004: ID 046d:08d7 Logitech, Inc. QuickCam Communicate STX
>
> [root@alarm ~]# v4lctl list
> attribute  | type   | current | default | comment
> -----------+--------+---------+---------+-------------------------------------
> norm       | choice | (null)  | (null)  |
> input      | choice | gspca_z | gspca_z | gspca_zc3xx
> bright     | int    |     128 |     128 | range is 0 => 255
> contrast   | int    |     128 |     128 | range is 0 => 255
> Gamma      | int    |       4 |       4 | range is 1 => 6
> Exposure   | int    |    2343 |    2343 | range is 781 => 18750
> Gain, Auto | bool   | on      | on      |
> Power Line | choice | Disable | Disable | Disabled 50 Hz 60 Hz
> Sharpness  | int    |       2 |       2 | range is 0 => 3
>
> The above output is complete, there is nothing else coming from dmesg.
> In Windows 7 64-bit with the webcam connected, while running Logitech Webcam Software, shows some extra info:
>
> Logitech QuickCam Communicate STX
> Hardware ID    USB\VID_046D&PID_08D7&REV_0100&MI_00
>
> Procmon output for LWS.exe (from Registry):
>
> ZC0302 chipset, Image Sensor HV7131B
>
> Attached to this message are exported webcam Registry settings (default and factual), and controls available for the webcam and optimally set by LWS. Also attached are datasheets for the webcam chipset and image sensor.
>
> The main problems now are:
>
> - Image Sensor can't be identified by gspca_zc3xx driver or verified since not shown in dmesg
> - Auto Gain is switched off permanently (despite shown On), and its choice range is missing
> - Color Saturation and White Balance controls are absent
> - Changes in image are unnoticed when adjusting Brightness and Contrast within their full range
>
> The webcam works with exposure and other adjustments manually changed over the day, but very difficult to get quality image in  evening low light. See also the discussion (https://bbs.archlinux.org/viewtopic.php?pid=879810#p879810) on how varying the driver's settings ("quality" and other) affects controls responsiveness ("brightness" and "contrast") and perceived image quality.
>
> Thanks,
> Sam
