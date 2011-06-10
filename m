Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:38734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1FJQHf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 12:07:35 -0400
Message-ID: <4DF2413F.6050307@redhat.com>
Date: Fri, 10 Jun 2011 13:07:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-verisign@hoogenraad.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: Media_build does not compile due to errors in cx18-driver.h,
 cx18-driver.c and dvbdev.c /rc-main.c
References: <4DF1FF06.4050502@hoogenraad.net>	<3e84c07f-83ff-4f83-9f8f-f52631259f05@email.android.com> <BANLkTinE1vRVJ+j+7JiPHZqXHJ8WTFX+cg@mail.gmail.com> <4DF21AA7.1010505@hoogenraad.net> <4DF226B7.1060602@hoogenraad.net> <4DF2399B.8010806@redhat.com>
In-Reply-To: <4DF2399B.8010806@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-06-2011 12:34, Mauro Carvalho Chehab escreveu:
> Em 10-06-2011 11:14, Jan Hoogenraad escreveu:
>> Sorry; too fast a reaction; I did not realize that the build script creates a version per kernel, and that my messages thus become hard to trace.
>>
>> The cx18 doubles were clear. The one in the code file may be caused by
>> v2.6.37_dont_use_alloc_ordered_workqueue.patch
>> but I don't see the problem in the header file in that patch.
>>
>>
>>
>> Below the 3 non cx18 offending lines:
>>
>> line in v4l2-dev.c:
>>
>>     printk(KERN_ERR "WARNING: You are using an experimental version of the media stack.\n\tAs the driver is backported to an older kernel, it doesn't offer\n\tenough quality for its usage in production.\n\tUse it with care.\nLatest git patches (needed if you report a bug to linux-media@vger.kernel.org):\n\t75125b9d44456e0cf2d1fbb72ae33c13415299d1 [media] DocBook: Don't be noisy at make cleanmediadocs\n\t0fba2f7ff0c4d9f48a5c334826a22db32f816a76 Revert \\"[media] dvb/audio.h: Remove definition for AUDIO_GET_PTS\\"\n\t4f75ad768da3c5952d1e7080045a5b5ce7b0d85d [media] DocBook/video.xml: Document the remaining data structures\n");
>>
>>
>> line in rc-main.c:
>>
>>     printk(KERN_ERR "WARNING: You are using an experimental version of the media stack.\n\tAs the driver is backported to an older kernel, it doesn't offer\n\tenough quality for its usage in production.\n\tUse it with care.\nLatest git patches (needed if you report a bug to linux-media@vger.kernel.org):\n\t75125b9d44456e0cf2d1fbb72ae33c13415299d1 [media] DocBook: Don't be noisy at make cleanmediadocs\n\t0fba2f7ff0c4d9f48a5c334826a22db32f816a76 Revert \\"[media] dvb/audio.h: Remove definition for AUDIO_GET_PTS\\"\n\t4f75ad768da3c5952d1e7080045a5b5ce7b0d85d [media] DocBook/video.xml: Document the remaining data structures\n");
>>
>>
>>
>> line in dvbdeb.c:
>>
>>
>>     printk(KERN_ERR "WARNING: You are using an experimental version of the media stack.\n\tAs the driver is backported to an older kernel, it doesn't offer\n\tenough quality for its usage in production.\n\tUse it with care.\nLatest git patches (needed if you report a bug to linux-media@vger.kernel.org):\n\t75125b9d44456e0cf2d1fbb72ae33c13415299d1 [media] DocBook: Don't be noisy at make cleanmediadocs\n\t0fba2f7ff0c4d9f48a5c334826a22db32f816a76 Revert \\"[media] dvb/audio.h: Remove definition for AUDIO_GET_PTS\\"\n\t4f75ad768da3c5952d1e7080045a5b5ce7b0d85d [media] DocBook/video.xml: Document the remaining data structures\n");
> 
> It seems to be caused by a bad escape sequence for the latest patch.
> I'll fix the Makefile script.
> 
> Thanks for reporting it.

Fixed. It is building fine right now, against RHEL 6.1 kernel (2.6.32-131).

Thanks,
Mauro.
