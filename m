Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:52913 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755519Ab1FJOXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 10:23:15 -0400
Message-ID: <4DF226B7.1060602@hoogenraad.net>
Date: Fri, 10 Jun 2011 16:14:15 +0200
From: Jan Hoogenraad <jan-verisign@hoogenraad.net>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: Media_build does not compile due to errors in cx18-driver.h,
 cx18-driver.c and dvbdev.c /rc-main.c
References: <4DF1FF06.4050502@hoogenraad.net>	<3e84c07f-83ff-4f83-9f8f-f52631259f05@email.android.com> <BANLkTinE1vRVJ+j+7JiPHZqXHJ8WTFX+cg@mail.gmail.com> <4DF21AA7.1010505@hoogenraad.net>
In-Reply-To: <4DF21AA7.1010505@hoogenraad.net>
Content-Type: multipart/mixed;
 boundary="------------070200010504080103040202"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------070200010504080103040202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sorry; too fast a reaction; I did not realize that the build script 
creates a version per kernel, and that my messages thus become hard to 
trace.

The cx18 doubles were clear. The one in the code file may be caused by
v2.6.37_dont_use_alloc_ordered_workqueue.patch
but I don't see the problem in the header file in that patch.



Below the 3 non cx18 offending lines:

line in v4l2-dev.c:

	printk(KERN_ERR "WARNING: You are using an experimental version of the 
media stack.\n\tAs the driver is backported to an older kernel, it 
doesn't offer\n\tenough quality for its usage in production.\n\tUse it 
with care.\nLatest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):\n\t75125b9d44456e0cf2d1fbb72ae33c13415299d1 [media] 
DocBook: Don't be noisy at make 
cleanmediadocs\n\t0fba2f7ff0c4d9f48a5c334826a22db32f816a76 Revert 
\\"[media] dvb/audio.h: Remove definition for 
AUDIO_GET_PTS\\"\n\t4f75ad768da3c5952d1e7080045a5b5ce7b0d85d [media] 
DocBook/video.xml: Document the remaining data structures\n");


line in rc-main.c:

	printk(KERN_ERR "WARNING: You are using an experimental version of the 
media stack.\n\tAs the driver is backported to an older kernel, it 
doesn't offer\n\tenough quality for its usage in production.\n\tUse it 
with care.\nLatest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):\n\t75125b9d44456e0cf2d1fbb72ae33c13415299d1 [media] 
DocBook: Don't be noisy at make 
cleanmediadocs\n\t0fba2f7ff0c4d9f48a5c334826a22db32f816a76 Revert 
\\"[media] dvb/audio.h: Remove definition for 
AUDIO_GET_PTS\\"\n\t4f75ad768da3c5952d1e7080045a5b5ce7b0d85d [media] 
DocBook/video.xml: Document the remaining data structures\n");



line in dvbdeb.c:


	printk(KERN_ERR "WARNING: You are using an experimental version of the 
media stack.\n\tAs the driver is backported to an older kernel, it 
doesn't offer\n\tenough quality for its usage in production.\n\tUse it 
with care.\nLatest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):\n\t75125b9d44456e0cf2d1fbb72ae33c13415299d1 [media] 
DocBook: Don't be noisy at make 
cleanmediadocs\n\t0fba2f7ff0c4d9f48a5c334826a22db32f816a76 Revert 
\\"[media] dvb/audio.h: Remove definition for 
AUDIO_GET_PTS\\"\n\t4f75ad768da3c5952d1e7080045a5b5ce7b0d85d [media] 
DocBook/video.xml: Document the remaining data structures\n");

Jan Hoogenraad wrote:
> Andy:
>
> Something along the line of id already defined.
> I just corrected the code by removing the duplicate lines that are in
> the sources of the tar.
>
> The other 3 files have a bad escape sequence in a line saying that this
> is the backports. One backslash not removed in a script, I guess.
>
> Devin:
>
> The version does not matter for the cx18 problem: any compiler complains
> on duplicate lines.
>
> Anyway: 2.6.32-32-generic-pae #62-Ubuntu SMP Wed Apr 20 22:10:33 UTC
> 2011 i686 GNU/Linux
>
> Devin Heitmueller wrote:
>> On Fri, Jun 10, 2011 at 8:34 AM, Andy Walls<awalls@md.metrocast.net>
>> wrote:
>>> What are the error messages?
>>>
>>> Tejun Heo made quite a number of workqueue changes, and the cx18
>>> driver got dragged forward with them. So did ivtv for that matter.
>>>
>>> Just disable the cx18 driver if you don't need it for an older kernel.
>>>
>>> Regards,
>>> Andy
>>
>> Another highly relevant piece of information to know is what kernel
>> Jan is running on. It is probably from before the workqueue changes.
>>
>> Devin
>>
>
>


--------------070200010504080103040202
Content-Type: text/x-vcard; charset=utf-8;
 name="jan-verisign.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="jan-verisign.vcf"

begin:vcard
fn:Jan Hoogenraad
n:Hoogenraad;Jan
org:Hoogenraad Interface Services
adr;quoted-printable;dom:;;Postbus 2717;Utrecht;;-- =
	=0D=0A=
	Jan Hoogenraad=0D=0A=
	Hoogenraad Interface Services=0D=0A=
	Postbus 2717=0D=0A=
	3500 GS
email;internet:jan-verisign@hoogenraad.net
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------070200010504080103040202--
