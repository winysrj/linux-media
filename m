Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab1FOOv4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 10:51:56 -0400
Message-ID: <4DF8C708.1050009@redhat.com>
Date: Wed, 15 Jun 2011 11:51:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com> <4DF8B716.1020406@redhat.com> <4DF8C0D2.5070900@redhat.com> <4DF8C32A.7090004@redhat.com>
In-Reply-To: <4DF8C32A.7090004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-06-2011 11:35, Hans de Goede escreveu:
> Hi,
> 
> On 06/15/2011 04:25 PM, Mauro Carvalho Chehab wrote:
>> Em 15-06-2011 10:43, Hans de Goede escreveu:
> 
> <snip>
> 
>>> Right, because ConsoleKit ensures that devices like floppydrives, cdroms, audio cards,
>>> webcams, etc. are only available to users sitting behind the console,
>>
>> This is a wrong assumption. There's no good reason why other users can't access those
>> devices.
> 
> This is not an assumption, this is a policy decision. The policy is that devices like
> audiocards and webcams should be only available to local console users / processes. To
> avoid for example someone from spying upon someone else sitting behind the computer.
> 
> <snip>

The concept behind the policy decision is right, but the policy itself and its 
implementation are wrong.

It makes sense to protect the access to the notebook/desktop microphone and webcam to
the console, but it doesn't make sense to assume that all audio cards and video devices
are microphones and webcams. There are several cases where they aren't, like mythtv/vdr
servers, Video Surveillance devices, TV boards, etc.

Also, I know at least one usecase where a Radio broadcast station is using an USB 
webcam to allow their audience to see what's happening there. So, even the assumption
that all webcams need protection is wrong (In this specific case, they really want
to allow someone else to spy what's happening there ;) ).

That's said, it is OK that the default will be to not allow accessing to them, but
adding someone else to the audio/video group should be enough to allow users to
override this protection.

Mauro.
