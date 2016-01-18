Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:37968 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175AbcARNbY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 08:31:24 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] Removal of the Timberdale v4l2 drivers timblogiw & radio-timb
Cc: richard@puffinpack.se, Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <569CE927.9040000@xs4all.nl>
Date: Mon, 18 Jan 2016 14:31:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Timberdale FPGA video and radio drivers have not seen any real
development since 2011 (and very little before that).

One of the problems with the timblogiw driver is that it uses videobuf
instead of the newer vb2 framework. Our long term goal is to either
convert or remove any driver still using videobuf. Since none of the
core v4l developers has the hardware, we cannot convert it ourselves.

As far as I can tell it was only used in an Intel demo board in 2009
using Meego:

http://www.chinait.com/intelcontent/intelprc/admin/PDFFile/20106411545.pdf

which has since been superseded.

I am inclined to remove the Timberdale support from drivers/media. First
by moving it to staging for one or two kernel releases, and then removing
it altogether.

Anyone still using it today would almost certainly be stuck on an old kernel.

Comments?

Regards,

	Hans
