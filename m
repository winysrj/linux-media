Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:45098 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbZCJRDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 13:03:22 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 21/31] video: Auto-load videodev module when device opened.
Date: Tue, 10 Mar 2009 18:03:16 +0100
Cc: Scott James Remnant <scott@canonical.com>,
	linux-kernel@vger.kernel.org, mchehab@infradead.org
References: <cover.1236702228.git.scott@canonical.com> <a52b15c14ef27828bc6d46c7b86fead07bc8422c.1236702228.git.scott@canonical.com>
In-Reply-To: <a52b15c14ef27828bc6d46c7b86fead07bc8422c.1236702228.git.scott@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903101803.17211.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Montag, 2. März 2009, Scott James Remnant wrote:
Hi Scott!

> The videodev module is missing the char-major-81-* alias that would
> cause it to be auto-loaded when a device of that type is opened.  This
> patch adds the alias.

The patch looks fine, but if videodev is not yet loaded, will loading videodev 
get any devices registered? For that to happen normally some pci video bridge 
adapter driver is needed, and that registers at videodev module.

Without modprobe.conf tricks this still is not loaded then.

Regards
Matthias
