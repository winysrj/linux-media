Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:52897 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZCDBPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 20:15:54 -0500
Received: by gxk22 with SMTP id 22so6090812gxk.13
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2009 17:15:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200903032329.54167.j@jannau.net>
References: <de8cad4d0903030450qf4063f1r9e4e53f5f83f1763@mail.gmail.com>
	 <200903032218.55382.hverkuil@xs4all.nl>
	 <200903032329.54167.j@jannau.net>
Date: Tue, 3 Mar 2009 20:15:50 -0500
Message-ID: <de8cad4d0903031715t2264c282x2ba4736deeb136cf@mail.gmail.com>
Subject: Re: Possible omission in v4l2-common.c?
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Janne Grunau <j@jannau.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 3, 2009 at 5:29 PM, Janne Grunau <j@jannau.net> wrote:
> On Tuesday 03 March 2009 22:18:55 Hans Verkuil wrote:
>> On Tuesday 03 March 2009 13:50:30 Brandon Jenkins wrote:
>> > Hello all,
>> >
>> > I was upgrading drivers this morning to capture the latest changes
>> > for the cx18 and I received a merge conflict in v4l2-common.c. In
>> > my system, 1 HDPVR and 3 CX18s. The HDPVR sources are 5 weeks old
>> > from their last sync up but contain:
>> >
>> > case V4L2_CID_SHARPNESS:
>> >
>> > The newer sources do not, but still have reference to sharpness at
>> > line 420: case V4L2_CID_SHARPNESS:                return
>> > "Sharpness";
>> >
>> > Because I don't know which way the code is going (is sharpness in
>> > or out) I can't submit a patch, but thought I would raise here.
>> > Diff below was pulled from clean clone of v4l-dvb tree.
>>
>> Sharpness is definitely in. This is a bug, please submit this patch
>> with a Signed-off-by line and I'll get it merged.
>
> It is and afaik was never handled in v4l2_ctrl_query_fill(), the hdpvr
> tree adds that. Since I intend request the merge of the driver in a
> couple of days a seperate patch shouldn't be needed.
>
> janne
>

This is interesting to me. I attempted to merge from a clean clone and
pull this morning. The only file which failed was v4l2-common.c.

Here's the fail marker:

<<<<<<< local
        case V4L2_CID_SHARPNESS:
=======
        case V4L2_CID_RED_BALANCE:
        case V4L2_CID_BLUE_BALANCE:
        case V4L2_CID_GAMMA:
>>>>>>> other

To produce this I did this from a clean start this morning:

hg clone http://hg.jannau.net/hdpvr/
cd hdpvr
hg pull http://linuxtv.org/hg/v4l-dvb/
hg merge
hg commit

I did the very same thing last week as well without a fail.

Brandon
