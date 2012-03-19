Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:40332 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab2CSOTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 10:19:52 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Various nits, fixes and hacks for mantis CA support on SMP
References: <20120228010330.GA25786@uio.no> <4F673D16.7010802@redhat.com>
	<20120319140742.GC8239@uio.no>
Date: Mon, 19 Mar 2012 15:19:09 +0100
In-Reply-To: <20120319140742.GC8239@uio.no> (Steinar H. Gunderson's message of
	"Mon, 19 Mar 2012 15:07:42 +0100")
Message-ID: <87ehsobrmq.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Steinar H. Gunderson" <sgunderson@bigfoot.com> writes:
> On Mon, Mar 19, 2012 at 11:05:10AM -0300, Mauro Carvalho Chehab wrote:
>> A "conglomerate of patches" can't be applied upstream. Instead, you should
>> be sending us a patch series, preserving the original author/signed-off-by
>> for each one, if the patches were nod written by you, and add your
>> Signed-off-by: at the end of each patch.
>
> This is true. I was, however, mainly looking for feedback -- it seems there
> is very little interest, though.

The user base is too small to get any feedback without getting the
patches into mainline.  I suggest you submit the parts you'd like to use
yourself.  That's the only way to get them tested.

I do have two mantis cards, but I don't have any CAM and I don't have
access to any DVB-C signal anymore. So that's why I didn't provide any
feedback despite being historically interested in this driver.



Bjørn
