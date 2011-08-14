Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:34249 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751020Ab1HNHaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 03:30:15 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org
Subject: TerraTec T6 Dual Tuner Stick initial support available
Date: Sun, 14 Aug 2011 09:30:07 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108140930.07873.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

just wanted to inform you that I got the TerraTec Dual DVB-T Stick working 
using a slightly patched driver from Afatech. Please see the wiki entry
http://www.linuxtv.org/wiki/index.php/TerraTec_T6_Dual_DVB-T_Stick
Currently both tuners work, but the remote doesn't.

This driver is only supposed to be a temporary solution until I have 
integrated the bits into Antti's af9035 driver, see
http://openee.googlecode.com/svn-history/r137/trunk/recipes/v4l-dvb/files/v4l-
dvb-af9035.patch
http://openee.googlecode.com/svn-history/r137/trunk/recipes/v4l-dvb/files/v4l-
dvb-af9033.patch

Regards,
Hans-Frieder

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
