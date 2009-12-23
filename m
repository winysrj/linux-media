Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55928 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbZLWKI4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 05:08:56 -0500
Date: Wed, 23 Dec 2009 11:08:50 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH 0/2] [ARM] Add Samsung S3C/S5P image rotator driver
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1261562933-26987-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this is a driver for Samsung S3C/S5P series image rotator device driver.
This driver utilizes the proposed memory-to-memory V4L2 framework, just posted
by me in the previous patch series.

An example application for testing the device is also included.


This series contains:

[PATCH 1/2] [ARM] samsung-rotator: Add rotator device platform definitions.
[PATCH 2/2] [ARM] samsung-rotator: Add Samsung S3C/S5P rotator driver
[EXAMPLE] S3C/S5P image rotator test application


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
