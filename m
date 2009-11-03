Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41516 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbZKCJB4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2009 04:01:56 -0500
Message-ID: <4AEFF16A.1040306@s5r6.in-berlin.de>
Date: Tue, 03 Nov 2009 10:01:30 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: mchehab@infradead.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org, rjw@sisk.pl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Henrik Kurelid <henke@kurelid.se>
Subject: Re: + firedtv-fix-regression-tuning-fails-due-to-bogus-error-return.patch
 added to -mm tree
References: <200911030646.nA36klJW017404@imap1.linux-foundation.org>
In-Reply-To: <200911030646.nA36klJW017404@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

akpm@linux-foundation.org wrote:
> The patch titled
>      firedtv: fix regression: tuning fails due to bogus error return
> has been added to the -mm tree.

Mauro,

this one (v4l-dvb patch 13240) as well as
    firedtv: length field corrupt in ca2host if length>127
(v4l-dvb patch 13237) are 2.6.32-rc material.  The ca2host fix is
possibly also good for 2.6.x.y, but this is something which Henrik knows
better than me.
-- 
Stefan Richter
-=====-==--= =-== ---==
http://arcgraph.de/sr/
