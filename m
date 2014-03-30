Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47299 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaC3RYo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 13:24:44 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy8y6ctXcc8qcqVkRDAL=ZWU0DAfuZ4zQcP6uqzPmb-AA@mail.gmail.com>
References: <532442E2.7050206@xs4all.nl>
	<532443AB.9080105@xs4all.nl>
	<533553E6.3060508@xs4all.nl>
	<CANeU7Qksj-tq0fjsZya1otX75sV4JOsAdXHr5Kxu-WyvYrksSw@mail.gmail.com>
	<533807FC.5050008@xs4all.nl>
	<CA+55aFy8y6ctXcc8qcqVkRDAL=ZWU0DAfuZ4zQcP6uqzPmb-AA@mail.gmail.com>
Date: Sun, 30 Mar 2014 10:24:43 -0700
Message-ID: <CA+55aFyKbV=Xg2q5Ci+QqPB22OnBu=aYs5kiBiaqnLGsP_4Zog@mail.gmail.com>
Subject: Re: sparse: ARRAY_SIZE and sparse array initialization
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Christopher Li <sparse@chrisli.org>,
	Linux-Sparse <linux-sparse@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 30, 2014 at 9:48 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll think about how to fix it cleanly. Expect a patch shortly.

Ok, patch sent to linux-sparse mailing list. It fixes the particular
cut-down test-case and seems pretty simple and straightforward, but is
otherwise entirely untested, so who the hell knows..

                  Linus
