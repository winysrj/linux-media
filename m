Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5FC0RNo032567
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 08:00:28 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au
	(outbound.icp-qv1-irony-out2.iinet.net.au [203.59.1.107])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5FC0FCq025757
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 08:00:17 -0400
Message-ID: <4855044D.7000702@iinet.net.au>
Date: Sun, 15 Jun 2008 20:00:13 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <48513259.6030003@iinet.net.au> <20080615083447.4d288a9e@gaivota>
In-Reply-To: <20080615083447.4d288a9e@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [PATCH] Avermedia A16d Avermedia E506
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Mauro Carvalho Chehab wrote:
> On Thu, 12 Jun 2008 22:27:37 +0800
> timf <timf@iinet.net.au> wrote:
>
>   
>> Hi Mauro,
>>
>> OK, Herewith find the patch for the Avermedia A16d, and the Avermedia 
>> E506 Cardbus.
>> I am using Thunderbird, so as well as pasting it here I shall attach it.
>> DVB-T, Analog-TV, FM-Radio - work for both cards.
>> Composite, S-Video not tested.
>>
>> Regards,
>> Timf
>>
>> Signed-off-by: Tim Farrington <timf@iinet.net.au>
>>
>>     
>
> Hi Tim,
>
> Your patch didn't apply:
>
> $ patch -p1 -i /home/v4l/tmp/mailimport23503/patch.diff
> patching file linux/drivers/media/common/ir-keymaps.c
> Hunk #1 succeeded at 2251 with fuzz 1.
> missing header for unified diff at line 898 of patch
> patching file linux/drivers/media/video/saa7134/saa7134-cards.c
> Hunk #1 FAILED at 4232.
> Hunk #2 FAILED at 4259.
> Hunk #3 FAILED at 4272.
> Hunk #4 FAILED at 5503.
> Hunk #5 FAILED at 5727.
> Hunk #6 FAILED at 5739.
> Hunk #7 FAILED at 5865.
> 7 out of 7 hunks FAILED -- saving rejects to file linux/drivers/media/video/saa7134/saa7134-cards.c.rej
> patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
> Hunk #1 FAILED at 153.
> Hunk #2 FAILED at 212.
> patch: **** malformed patch at line 1073: &avermedia_xc3028_mt352_dev,
>
> Also, running checkpatch.pl generates lots of codingstyle errors and warnings.
>
> Please, re-generate it against the latest tree, fix coding style and be sure
> that your emailer is not breaking long lines or replacing tabs with spaces. If
> you're using thunderbird, maybe it would be better to send, instead, as an
> attachment.
>
>
>
> Cheers,
> Mauro
>
>   
Hi Mauro,
I'm a lttle confused.
I simply cloned via hg into a directory.
I copied that v4l-dvb as v4l-dvb-a16d-e506.
I then modified v4l-dvb-a16d-e506 with my mods.
I then did: diff -upr v4l-dvb v4l-dvb-a16d-e506r
I made a 2nd copy of v4l-dvb in another directory.
In that 2nd directory I did: patch -p0 < v4l-dvb-a16d-e506.diff
I had no errors.
I then did diff -upr ../v4l-dvb v4l-dvb-a16d-e506
which produced no differences.
I applied checkpatch.pl with no errors.
I then emailed you the v4l-dvb-a16d-e506.diff file as an attachment.


I have tried using hg diff ...
but it bails out with a message about mine not being a mercurial depository.

Did you check with the attachment? as I said in the email that I was 
using Thunderbird.

When I produced the patch, it was against the then current mercurial, 3 
days ago.

Regards,
Tim Farrington

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
