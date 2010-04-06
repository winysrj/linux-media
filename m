Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38902 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0DFLot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 07:44:49 -0400
Received: by bwz1 with SMTP id 1so3517275bwz.21
        for <linux-media@vger.kernel.org>; Tue, 06 Apr 2010 04:44:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201004061327.05929.laurent.pinchart@ideasonboard.com>
References: <201004052347.10845.hverkuil@xs4all.nl>
	 <201004060837.24770.hverkuil@xs4all.nl>
	 <1270551978.3025.38.camel@palomino.walls.org>
	 <201004061327.05929.laurent.pinchart@ideasonboard.com>
Date: Tue, 6 Apr 2010 13:44:47 +0200
Message-ID: <t2wd9def9db1004060444o3c251ed6g7967b9f594ebd421@mail.gmail.com>
Subject: Re: RFC: exposing controls in sysfs
From: Markus Rechberger <mrechberger@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mike Isely <isely@isely.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 6, 2010 at 1:27 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Andy,
>
> On Tuesday 06 April 2010 13:06:18 Andy Walls wrote:
>> On Tue, 2010-04-06 at 08:37 +0200, Hans Verkuil wrote:
>
> [snip]
>
>> > Again, I still don't know whether we should do this. It is dangerously
>> > seductive because it would be so trivial to implement.
>>
>> It's like watching ships run aground on a shallow sandbar that all the
>> locals know about.  The waters off of 'Point /sys' are full of usability
>> shipwrecks.  I don't know if it's some siren's song, the lack of a light
>> house, or just strange currents that deceive even seasoned
>> navigators....
>>
>> Let the user run 'v4l2-ctl -d /dev/videoN -L' to learn about the control
>> metatdata.  It's not as easy as typing 'cat', but the user base using
>> sysfs in an interactive shell or shell script should also know how to
>> use v4l2-ctl.  In embedded systems, the final system deployment should
>> not need the control metadata available from sysfs in a command shell
>> anyway.
>
> I fully agree with this. If we push the idea one step further, why do we need
> to expose controls in sysfs at all ?
>

how about security permissions? while you can easily change the
permission levels for nodes in /dev you can't do this so easily with
sysfs entries.
I don't really think this is needed at all some applications will
start to use ioctl some other apps might
go for sysfs.. this makes the API a little bit whacko

Markus
