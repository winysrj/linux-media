Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44228 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753657AbaDJWWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:22:08 -0400
Message-ID: <5347198D.2040502@iki.fi>
Date: Fri, 11 Apr 2014 01:22:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 1/9] Provide -Q option for setting the queue type
References: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sakari Ailus wrote:
> Instead of guessing the queue type, allow setting it explicitly.

These got out a little bit too fast... what would you expect git 
send-email to do if you press ^C?

Changes since v1:

- Replace --output (-o, for which getopt handling was actually missing) 
option with a more generic --queue-type (-Q) option.
- Cleaned up queue type setting; there are now separate functions for 
opening the video device, querying its capabilities and setting the 
queue type
- The user-set timestamp source flags are no longer printed
- Removed the accidental --userptr option handling change

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
