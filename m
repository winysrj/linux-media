Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609Ab0BQVTj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 16:19:39 -0500
Message-ID: <4B7C5D60.3010208@redhat.com>
Date: Wed, 17 Feb 2010 19:19:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] V4L/DVB: v4l: document new Bayer and monochrome pixel
 formats
References: <4B7C239D.6010609@redhat.com> <Pine.LNX.4.64.1002172153020.4623@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1002172153020.4623@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Wed, 17 Feb 2010, Mauro Carvalho Chehab wrote:
> 
>> Document all four 10-bit Bayer formats, 10-bit monochrome and a missing
>> 8-bit Bayer formats.
>>
>> [mchehab@redhat.com: remove duplicated symbol for V4L2-PIX-FMT-SGRBG10]
>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  Documentation/DocBook/Makefile               |    3 +
>>  Documentation/DocBook/v4l/pixfmt-srggb10.xml |   90 ++++++++++++++++++++++++++
>>  Documentation/DocBook/v4l/pixfmt-srggb8.xml  |   67 +++++++++++++++++++
>>  Documentation/DocBook/v4l/pixfmt-y10.xml     |   79 ++++++++++++++++++++++
>>  Documentation/DocBook/v4l/pixfmt.xml         |    8 +--
>>  5 files changed, 242 insertions(+), 5 deletions(-)
>>  create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb10.xml
>>  create mode 100644 Documentation/DocBook/v4l/pixfmt-srggb8.xml
>>  create mode 100644 Documentation/DocBook/v4l/pixfmt-y10.xml
>>
>> diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
>> index 65deaba..1c796fc 100644
>> --- a/Documentation/DocBook/Makefile
>> +++ b/Documentation/DocBook/Makefile
>> @@ -309,6 +309,9 @@ V4L_SGMLS = \
>>  	v4l/pixfmt-yuv422p.xml \
>>  	v4l/pixfmt-yuyv.xml \
>>  	v4l/pixfmt-yvyu.xml \
>> +	v4l/pixfmt-srggb10.xml \
>> +	v4l/pixfmt-srggb8.xml \
>> +	v4l/pixfmt-y10.xml \
> 
> Mauro, why didn't you put them next to similar formats, as in my original 
> patch?

Guennadi,

Your original patch were against the out-of-tree "media-specs/Makefile", present
only at the -hg tree. 

The way my conversion scripts work is that they'll convert the patches into a
patch that can be applied directly into -git. Among other things, all
changes on files outside the kernel tree are simply discarded by them.
 
Also, before patch 2/4, such addition won't be possible.

So, what happened here is that, after importing from your hg tree, I noticed 
-git compilation breakage. So, I ported the autobuild bits for media-entities & co,
manually added the missing pixfmt xml's and removed the duplicate symbol for one
of the bayer standards.

That's said, I don't really have any preference about the order where the files appear
at the Makefile. I have no objection if you prefer to add them on any other random order.

In a matter of fact, IMO, the better is to later write a patch that discards
this static list of files, auto-generating it dynamically.

So, if you really prefer a different order, please re-submit another version for this patch.

Cheers,
Mauro
