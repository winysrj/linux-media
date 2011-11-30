Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43898 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab1K3N1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 08:27:47 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: RE: [PATCH] board-dm646x-evm.c: wrong register used in
 setup_vpif_input_channel_mode
Date: Wed, 30 Nov 2011 13:27:38 +0000
Message-ID: <DF0F476B391FA8409C78302C7BA518B6035772@DBDE01.ent.ti.com>
References: <1321294849-2738-1-git-send-email-hverkuil@xs4all.nl>
 <986dc5c6de4525aa3427ccded735d8e982080b0e.1321294701.git.hans.verkuil@cisco.com>
In-Reply-To: <986dc5c6de4525aa3427ccded735d8e982080b0e.1321294701.git.hans.verkuil@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Nov 14, 2011 at 23:50:49, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The function setup_vpif_input_channel_mode() used the VSCLKDIS register
> instead of VIDCLKCTL. This meant that when in HD mode videoport channel 0
> used a different clock from channel 1.
> 
> Clearly a copy-and-paste error.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Queuing this for v3.2-rc. I changed the headline to match current convention
Being used in ARM:

ARM: davinci: dm646x evm: wrong register used in setup_vpif_input_channel_mode

Also, the code in question has not changed for a long time, so added the
stable tag.

Regards,
Sekhar

