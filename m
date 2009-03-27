Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:48922 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZC0GUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 02:20:54 -0400
Received: by ti-out-0910.google.com with SMTP id i7so640027tid.23
        for <linux-media@vger.kernel.org>; Thu, 26 Mar 2009 23:20:51 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 27 Mar 2009 15:20:51 +0900
Message-ID: <b64afca20903262320g1bd35163lcce41724dd5db965@mail.gmail.com>
Subject: how about adding FOCUS mode?
From: "Kim, Heung Jun" <riverful@gmail.com>
To: bill@thedirks.org, hverkuil@xs4all.nl, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Hans & everyone.

I'm trying to adapt the various FOCUS MODE int the NEC ISP driver.
NEC ISP supports 4 focus mode, AUTO/MACRO/MANUAL/FULL or NORMAL.
but, i think that it's a little insufficient to use V4L2 FOCUS Feature.

so, suggest that,

- change V4L2_CID_FOCUS_AUTO's type from boolean to interger, and add
the following enumerations for CID values.

enum v4l2_focus_mode {
    V4L2_FOCUS_AUTO            = 0,
    V4L2_FOCUS_MACRO        = 1,
    V4L2_FOCUS_MANUAL        = 2,
    V4L2_FOCUS_NORMAL        = 3,
    V4L2_FOCUS_LASTP        = 3,
};

how about this usage? i wanna get some advice about FOCUS MODE.

Thanks,
Riverful
