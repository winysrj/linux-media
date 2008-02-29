Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smeagol.cambrium.nl ([217.19.16.145] ident=qmailr)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1JV914-0004Fv-VV
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 18:27:27 +0100
Message-ID: <47C84079.6060203@powercraft.nl>
Date: Fri, 29 Feb 2008 18:27:21 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <47C83611.1040805@powercraft.nl>	
	<d9def9db0802290848v100ca9dcm22292e368bec4ad5@mail.gmail.com>	
	<47C83919.4010102@powercraft.nl>
	<d9def9db0802290901v74aa7889oab2b6e4c22057f@mail.gmail.com>
In-Reply-To: <d9def9db0802290901v74aa7889oab2b6e4c22057f@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------000803080504020204050201"
Cc: linux-dvb <linux-dvb@linuxtv.org>, em28xx@mcentral.de
Subject: Re: [linux-dvb] Pinnacle PCTV Hybrid Pro Stick 330e - Installation
 Guide - v0.1.2j
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------000803080504020204050201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Markus Rechberger wrote:
> On 2/29/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
>> Markus Rechberger wrote:
>>> Hi Jelle,
>>>
>>> On 2/29/08, Jelle de Jong <jelledejong@powercraft.nl> wrote:
>>>> This message contains the following attachment(s):
>>>> Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt
>>>>
>>> the correct mailinglist for those devices is em28xx at mcentral dot de
>>>
>>> I added some comments below and prefixed them with /////////
>>>
>>> This message contains the following attachment(s):
>>> Pinnacle PCTV Hybrid Pro Stick 330e - Installation Guide - v0.1.2j.txt
>>>
>> We will get it working in the next few days, i am already working on a
>> user guide. I will add the comments to the new version, i just thought
>> release as soon as possible, dont want somebody else to spent hours and
>> hours of his day installing your nice driver.
>>
>> Nice, I was working on building tvtime but it gave me errors,
>>
> 
> libasound2-dev and the linux kernel headers or at least a symlink from
> /usr/include/linux -> kernelroot/include/linux is missing.
> 
> It would be nice if you can create a howto on mcentral.de! I'm sure it
> might help some people. My guide only explains how to compile it on a
> already set up system (and this can differ with every distribution).
> 
> I will release precompiled packages for the eeePC within the next few
> days. I just need to package the binaries for it.
> I added tvtime, gqradio and kaffeine buttons to my eeePC and
> everything works really well.
> I'll focus on ATSC devices next week (after the cebit)
> 
> thanks for the howto so far!
> 
> Markus

I will work on the docu you on the nice code :-p

Just one thing how to fix the below? Than we can release a first draft. 
We need a group that is compatiable with udev and the driver, so that we 
can do adduser $USER $GROUP to give premissions to use the devices

# to-do:
# howto add group for created devices so that all users in that group 
can use the devices?

oja also i cant get /dev/vdi0 working

Kind regards,

Jelle

--------------000803080504020204050201
Content-Type: text/plain;
 name="sudo mtt -debug -tty -device -dev-vbi0 - logfile.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="sudo mtt -debug -tty -device -dev-vbi0 - logfile.txt"

sudo mtt -debug -tty -device /dev/vbi0
Try to open V4L2 0.20 VBI device, libzvbi interface rev.
  $Id: io-v4l2.c,v 1.33 2006/05/22 09:00:47 mschimek Exp $
Opened /dev/vbi0
libzvbi:capture_v4l2k_new: Try to open V4L2 2.6 VBI device, libzvbi interface rev.
  $Id: io-v4l2k.c,v 1.42 2006/09/24 03:10:04 mschimek Exp $.
libzvbi:capture_v4l2k_new: Opened /dev/vbi0.
libzvbi:capture_v4l2k_new: /dev/vbi0 (Pinnacle Hybrid Pro (2)) is a v4l2 vbi device,
driver em28xx, version 0x00000001.
libzvbi:capture_v4l2k_new: Using streaming interface.
libzvbi:v4l2_get_videostd: Current scanning system is 625.
libzvbi:v4l2_update_services: Querying current vbi parameters...
libzvbi:v4l2_update_services: ...success.
libzvbi:print_vfmt: VBI capture parameters supported: format 59455247 [GREY], 13500000 Hz, 720 bpl, offs 0, F1 15...20, F2 10...15, flags 00000000.
libzvbi:print_vfmt: VBI capture parameters granted: format 59455247 [GREY], 13500000 Hz, 720 bpl, offs 0, F1 15...20, F2 10...15, flags 00000000.
libzvbi:_vbi_sampling_par_valid_log: Invalid VBI scan range 15-20 (6 lines), 10-15 (6 lines).
libzvbi:v4l2_update_services: Nyquist check passed.
libzvbi:v4l2_update_services: Request decoding of services 0x60000c7f, strict level -1.
libzvbi:_vbi_sampling_par_permit_service: Service 0x00000001 (Teletext System B 625 Level 1.5) requires videostd_set 0x1, have 0x0.
libzvbi:_vbi_sampling_par_permit_service: Service 0x00000003 (Teletext System B, 625) requires videostd_set 0x1, have 0x0.
libzvbi:_vbi_sampling_par_permit_service: Service 0x00000001 (Teletext System B 625 Level 1.5) requires videostd_set 0x1, have 0x0.
libzvbi:_vbi_sampling_par_permit_service: Service 0x00000003 (Teletext System B, 625) requires videostd_set 0x1, have 0x0.
libzvbi:_vbi_sampling_par_permit_service: Service 0x00000004 (Video Program System) requires videostd_set 0x1, have 0x0.
libzvbi:_vbi_sampling_par_permit_service: Service 0x00000400 (Wide Screen Signalling 625) requires videostd_set 0x1, have 0x0.
libzvbi:_vbi_sampling_par_permit_service: Service 0x00000008 (Closed Caption 625, field 1) requires videostd_set 0x1, have 0x0.
libzvbi:_vbi_sampling_par_permit_service: Service 0x00000010 (Closed Caption 625, field 2) requires videostd_set 0x1, have 0x0.
libzvbi:_vbi_sampling_par_permit_service: Service 0x00000020 (Closed Caption 525, field 1) requires videostd_set 0x2, have 0x0.
libzvbi:_vbi_sampling_par_permit_service: Service 0x00000040 (Closed Caption 525, field 2) requires videostd_set 0x2, have 0x0.
libzvbi:v4l2_update_services: Will capture services 0x00000000, added 0x0 commit=1.
libzvbi:capture_v4l2k_new: Failed with errno 22, errmsg 'Sorry, /dev/vbi0 (Pinnacle Hybrid Pro (2)) cannot capture any of the requested data services.'.
libzvbi: Try to open v4l vbi device, libzvbi interface rev.
  $Id: io-v4l.c,v 1.33 2006/05/22 09:01:04 mschimek Exp $
libzvbi: Opened /dev/vbi0
libzvbi: Driver name 'Pinnacle Hybrid Pro (2)'
libzvbi: Attempt to guess the videostandard
libzvbi: Driver supports VIDIOCGTUNER: mode 0 (0=PAL, 1=NTSC, 2=SECAM)
libzvbi: Videostandard is PAL/SECAM
libzvbi: /dev/vbi0 (Pinnacle Hybrid Pro (2)) is a v4l vbi device
libzvbi: Hinted video standard 0, guessed 625
libzvbi: Driver supports VIDIOCGVBIFMT, guessed videostandard 525
VBI capture parameters supported: format 0000000c, 13500000 Hz, 720 bpl, F1 15+6, F2 10+6, flags 00000000
VBI capture parameters granted: format 0000000c, 13500000 Hz, 720 bpl, F1 15+6, F2 10+6, flags 00000000
libzvbi: Accept current vbi parameters
libzvbi: Nyquist check passed
libzvbi: Request decoding of services 0x60000c7f, strict level -1
libzvbi: Will capture services 0x00000000, added 0x0 commit:1
vbi: open failed [/dev/vbi0]

--------------000803080504020204050201
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000803080504020204050201--
