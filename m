Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out116.alice.it ([85.37.17.116]:4844 "EHLO
	smtp-out116.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030792Ab0B0UbJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 15:31:09 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	Max Thrun <bear24rw@gmail.com>,
	Mosalam Ebrahimi <m.ebrahimi@ieee.org>
Subject: [PATCH 00/11] ov534: Fixes and updates
Date: Sat, 27 Feb 2010 21:20:17 +0100
Message-Id: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Francois,

will you review/apply these changes please?

Several fixes and updates:
 * Removed some controls because their state was not good enough
 * Added AEC
 * AGC and AWB enabled by default
 * Fixed setting/unsetting registers for
     - exposure
     - sharpness
     - hflip
     - vflip
 * Fixed coding style
 * Added Powerline Frequency control

The only big behavioural change should be AGC enabled by default, if
users want autogain disabled by default we can rediscuss this again.

Special thanks to Max Thrun and Mosalam Ebrahimi.

Regards,
   Antonio

-- 
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?
