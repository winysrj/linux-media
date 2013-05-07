Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42179 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab3EGQYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 12:24:39 -0400
Received: by mail-wg0-f47.google.com with SMTP id e11so807303wgh.2
        for <linux-media@vger.kernel.org>; Tue, 07 May 2013 09:24:38 -0700 (PDT)
From: Konke Radlow <koradlow@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [RFC PATCH 0/4] libv4l2rds: support for decoding RDS tuning information
Date: Tue,  7 May 2013 17:24:19 +0100
Message-Id: <1367943863-28803-1-git-send-email-koradlow@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This set of patches adds support to decode information about other networks and radio
stations which can submitted as a part of the RDS and RDS-TMC data stream.

RDS-EON: Enhanced Other Network information that can be used to update the information stored in the receiver about programme service other than the one received. Alternative frequencies, the PS name, Traffic Programme and Traffic Announcement identification as well as Programme Type and Programme Item Number information can be transmitted for each other service.

RDS-TMC-Tuning: Detailed information about other stations that carry the same RDS-TMC service that can be used by terminals to tune directly to a new station at boundaries of a transmitter's coverage.

