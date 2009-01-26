Return-path: <linux-media-owner@vger.kernel.org>
Received: from joan.kewl.org ([212.161.35.248]:44966 "EHLO joan.kewl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZAZSFr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 13:05:47 -0500
From: Darron Broad <darron@kewl.org>
To: linux-media@vger.kernel.org, Alex Betis <alex.betis@gmail.com>
cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to use scan-s2? 
In-reply-to: <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com> 
References: <497C3F0F.1040107@makhutov.org> <497C359C.5090308@okg-computer.de> <c74595dc0901250525y3771df4fhb03939c9c9c02c1f@mail.gmail.com> <Pine.LNX.4.64.0901260109400.12123@shogun.pilppa.org> <c74595dc0901260135x32f7c2bm59506de420dab978@mail.gmail.com> <Pine.LNX.4.64.0901261729280.19881@shogun.pilppa.org> <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com>
Date: Mon, 26 Jan 2009 17:32:31 +0000
Message-ID: <16900.1232991151@kewl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In message <c74595dc0901260753x8b9185fu33f2a96ffbe13016@mail.gmail.com>, Alex Betis wrote:

lo

<snip>
>
>The bug is in S2API that doesn't return ANY error message at all :)
>So the tuner is left locked on previous channel.
>
>There are many things that can be done in driver to improve the situation,
>but I'll leave it to someone who has card with cx24116 chips.

When tuning the event status should change to 0 and if
it stays that way the tuning operation failed.

If you read the frontend status directly then you will
retrieve the state of the previous tuning operation
that suceeded. 

If this the above is not true then it needs investigation.

cya

