Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46533 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751038AbaKRFn7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 00:43:59 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 3D8C960093
	for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 07:43:56 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH v2 00/11] smiapp OF support
Date: Tue, 18 Nov 2014 07:43:35 +0200
Message-Id: <1416289426-804-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This patchset adds support for Device tree in the smiapp driver. Platform       
data support is retained as well. The actual DT related changes are             
prepended by a few simple cleanups.                                             
                                                                                
A new link-frequency property is defined in video-interfaces.txt, as this is    
hardly something which is specific to the SMIA compliant sensors.               

since v1:

- Only use dev->of_node to determine whether the OF node is there.

- Add clock-lanes and data-lanes properties to mandatory properties list in
  documentation.

- Add a patch to include include/uapi/linux/smiapp.h in MAINTAINERS section
  for the smiapp driver.

-- 
Kind regards,
Sakari
