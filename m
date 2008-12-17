Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHGs9t4016907
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 11:54:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBHGqxXs032382
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 11:52:59 -0500
Date: Wed, 17 Dec 2008 14:52:15 -0200 (BRST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812171527140.5465@axis700.grange>
Message-ID: <alpine.LRH.2.00.0812171449530.30974@caramujo.chehab.org>
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
	<20080205080038.GB8232@plankton.ifup.org>
	<20080205102409.4b7acb01@gaivota>
	<20080213202055.GA26352@plankton.ifup.org>
	<20080214174602.4ed91987@gaivota>
	<Pine.LNX.4.64.0812171444420.5465@axis700.grange>
	<49490A4B.90609@linuxtv.org>
	<Pine.LNX.4.64.0812171527140.5465@axis700.grange>
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

> On Wed, 17 Dec 2008, Michael Krufky wrote:
>
>> Please take a look at one of the hg patches within the repository:
>>
>> http://linuxtv.org/hg/v4l-dvb/raw-rev/3cc7daa31234
>>
>> This patch is the same type of output that you would get from using "hg export
>> 3cc7daa31234"
>>
>> Notice the "From:" line -- that line is used to indicate author.
>>
>> Notice the "User" line (line 2) -- that line is used to indicate committer.
>>
>> Does that help to clear it up for you?
>
> Maybe... So, if I take a patch produced by git-format-patch, and add a
> line at the top like
>
> # User myname <myaddress@myprovider.com>
>
> and then "hg import" this patch, then this line will be used by hg for the
> "user" field and the "From: " line that git produced will be kept... emn
> no, it will not, because it belongs to the header. But ok, I think, I know
> what should be done. I'll just move the "From: " from the header to below
> the "Subject: ", and, optionally add one more "# User " or "From: " for
> the user... uhhh...

I use here a simpler procedure to retrieve patches from other file 
systems. Instead of doing "hg import <patch>", I use:

./mailimport <patch>

The mailimport script do the proper patch import, and also allows you to 
review the patch before committing.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
