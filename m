Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHIOogv012747
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:24:50 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mBHIOYti006276
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:24:34 -0500
Date: Wed, 17 Dec 2008 16:23:27 -0200 (BRST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812171802300.5465@axis700.grange>
Message-ID: <alpine.LRH.2.00.0812171620480.30974@caramujo.chehab.org>
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
	<20080205080038.GB8232@plankton.ifup.org>
	<20080205102409.4b7acb01@gaivota>
	<20080213202055.GA26352@plankton.ifup.org>
	<20080214174602.4ed91987@gaivota>
	<Pine.LNX.4.64.0812171444420.5465@axis700.grange>
	<49490A4B.90609@linuxtv.org>
	<Pine.LNX.4.64.0812171527140.5465@axis700.grange>
	<alpine.LRH.2.00.0812171449530.30974@caramujo.chehab.org>
	<Pine.LNX.4.64.0812171802300.5465@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com, Michael Krufky <mkrufky@linuxtv.org>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] Moving to git for v4l-dvb
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

On Wed, 17 Dec 2008, Guennadi Liakhovetski wrote:

> On Wed, 17 Dec 2008, Mauro Carvalho Chehab wrote:
>
>> On Wed, 17 Dec 2008, Guennadi Liakhovetski wrote:
>>
>>> Maybe... So, if I take a patch produced by git-format-patch, and add a
>>> line at the top like
>>>
>>> # User myname <myaddress@myprovider.com>
>>>
>>> and then "hg import" this patch, then this line will be used by hg for the
>>> "user" field and the "From: " line that git produced will be kept... emn
>>> no, it will not, because it belongs to the header. But ok, I think, I know
>>> what should be done. I'll just move the "From: " from the header to below
>>> the "Subject: ", and, optionally add one more "# User " or "From: " for
>>> the user... uhhh...
>>
>> I use here a simpler procedure to retrieve patches from other file systems.
>> Instead of doing "hg import <patch>", I use:
>>
>> ./mailimport <patch>
>>
>> The mailimport script do the proper patch import, and also allows you to
>> review the patch before committing.
>
> and in which form does the patch have to be when using mailimport? Would
> output from git-format-patch suit?

I made it to accept several common formats, including -git and also akpm 
posts for -mm series.
>
> In the meantime here's an example of what my self-baked script produces
> (after "hg import" as seen per "hg export"):
>
> # HG changeset patch
> # User Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> # Date 1229533267 -3600
> # Node ID 3fd17fb56af0a556ab85509fb50956a477b14916
> # Parent  3cc7daa31234ca3c9bd0a58eb825f61499a65826
> mt9m111: mt9m111_get_global_gain() - unsigned >= 0 is always true
> From: roel kluin <roel.kluin@gmail.com>
>
> unsigned >= 0 is always true and fix formula
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> drivers/media/video/mt9m111.c |   13 +++++--------
> 1 files changed, 5 insertions(+), 8 deletions(-)
>
> diff -r 3cc7daa31234 -r 3fd17fb56af0 linux/drivers/media/video/mt9m111.c
> --- a/linux/drivers/media/video/mt9m111.c       Tue Dec 16 23:04:56 2008 -0200
> +++ b/linux/drivers/media/video/mt9m111.c       Wed Dec 17 18:01:07 2008 +0100
> @@ -634,18 +634,15 @@ static int mt9m111_set_flip(struct soc_c
> ...
>
> Should work, right?

Should work. We generally add a space after the first line and From:

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
