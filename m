Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34963 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaKETwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 14:52:44 -0500
Received: by mail-pd0-f180.google.com with SMTP id ft15so1372221pdb.11
        for <linux-media@vger.kernel.org>; Wed, 05 Nov 2014 11:52:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANZNk82AqfbSkUd_xONtjAxLePA0TMhS_5wuWERObyGSZ5QYoA@mail.gmail.com>
References: <CANZNk82AqfbSkUd_xONtjAxLePA0TMhS_5wuWERObyGSZ5QYoA@mail.gmail.com>
Date: Wed, 5 Nov 2014 23:52:44 +0400
Message-ID: <CANZNk81oAbQ+t3gNqMH6b=ieGfyxEJu7oT=oFY9xABv=t7+f=w@mail.gmail.com>
Subject: Re: v4l2-ctl bug(?) printing ctrl payload array
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>, hans.verkuil@cisco.com,
	Gregor Jasny <gjasny@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More on the same topic.
I believe there's another bug on displaying of payload.
Let's say we have the same [45][45] array, and this is what is posted to it:
uint16_t buf[45 * 45] = {0, };
        buf[0] = 1;
        buf[1] = 2;
        buf[45] = 3;
        buf[45 * 45 - 1] = 0xff;

What is shown by v4l2-ctl you can see here:
https://dl.dropboxusercontent.com/u/43104344/v4l2-ctl_payload_bug.png

-- 
Andrey Utkin
