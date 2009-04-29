Return-path: <linux-media-owner@vger.kernel.org>
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:51427 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268AbZD2BjH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 21:39:07 -0400
Message-ID: <49F7AFB8.1050002@andrew.cmu.edu>
Date: Tue, 28 Apr 2009 21:39:04 -0400
From: Josh Watzman <jwatzman@andrew.cmu.edu>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: Robert Krakora <rob.krakora@gmail.com>,
	Janne Grunau <j@jannau.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Panic in HVR-950q caused by changeset 11356
References: <412bdbff0904271903o6a66c48co87b8b1829be2f62f@mail.gmail.com>	 <b24e53350904280942s1cb0df20wc5b5e4ba671fc008@mail.gmail.com> <412bdbff0904280945j15e0600aq72a6a8aba36bc1e7@mail.gmail.com>
In-Reply-To: <412bdbff0904280945j15e0600aq72a6a8aba36bc1e7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> I discussed it at length with Janneg on #linuxtv this morning.  A pull
> request has been submitted with the fix, marked high priority.

I just pulled and built from the main hg tree, and in a simple test it
did not oops on disconnect! Thanks for everyone's work, and I'll
continue to test over the next week or so and let you know if it happens
again.

(Also, thanks for the CC, and please continue to do so on anything
related to this issue; I unsubscribed from the list a few days ago due
to the relatively high traffic.)

Josh Watzman

