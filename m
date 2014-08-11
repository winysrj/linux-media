Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:60511 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaHKMFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 08:05:40 -0400
From: Ian Molton <ian.molton@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	robh+dt@kernel.org, devicetree@vger.kernel.org, lars@metafoo.de,
	shubhrajyoti@ti.com, william-towle@codethink.co.uk,
	ian.molton@codethink.co.uk
Subject: [PATCH 0/1 v1] adv7604: Add adv7612 support
Date: Mon, 11 Aug 2014 13:05:17 +0100
Message-Id: <1407758719-12474-1-git-send-email-ian.molton@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This small patch series adds initial support for the adv7612 dual HDMI input
decoder chip and adds a device-tree option allowing the default input to be
selected.

Please review / apply,

-Ian

