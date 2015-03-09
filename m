Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:52377 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbbCILGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 07:06:47 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] uvcvideo: Don't call vb2 mmap and get_unmapped_area with queue lock held
References: <1424111134-22413-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<87k2z9558i.fsf@nemi.mork.no>
Date: Mon, 09 Mar 2015 12:06:36 +0100
In-Reply-To: <87k2z9558i.fsf@nemi.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of "Mon, 23
	Feb 2015 10:47:41 +0100")
Message-ID: <871tkye8g3.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bjørn Mork <bjorn@mork.no> writes:
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> writes:
>
>> Bjørn, does this fix the circular locking dependency you have reported in
>> "[v3.19-rc7] possible circular locking dependency in uvc_queue_streamoff" ?
>> The report mentions involves locks, so I'm not 100% this patch will fix the
>> issue.
>
> Sorry, I forgot all about that report after firing it off...  Should
> have followed it up with some more details.
>
> Grepping my logs now I cannot find this warning at all after the one I
> reported.  I see it once before (while running 3.19-rc6).  So it is
> definitely not easily reproducible.  And I have a bad feeling the
> trigger might involve completely unrelated USB issues...
>
> In any case, thanks for the patch.  I will test it for a while and let
> you know if the same warning shows ut with it.  But based on the rare
> occurence, I don't think I ever will be able to positively confirm that
> the warning is gone.

FWIW, I have not seen the warning after applying this patch, so it
appears to fix the problem.  Thanks.

If I'm wrong, then I'm sure Murphy will tell us as soon as I send this
email :-)


Bjørn
