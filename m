Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36705 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbcLFQIL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 11:08:11 -0500
Received: by mail-pf0-f195.google.com with SMTP id c4so18936975pfb.3
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2016 08:08:10 -0800 (PST)
From: evgeni.raikhel@gmail.com
To: linux-media@vger.kernel.org
Cc: sergey.dorodnicov@intel.com, eliezer.tamir@intel.com,
        evgeni.raikhel@intel.com, laurent.pinchart@ideasonboard.com
Subject: Intel SR300 Depth Camera formats
Date: Tue,  6 Dec 2016 18:04:33 +0200
Message-Id: <1481040275-18392-1-git-send-email-evgeni.raikhel@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Changelog for v2:

1. The patch has been rearranged, so instead of  separation into "Code" 
and "Documentation" segments it is built around:
- Adding new INZI format definition to V4L2_API
- Adding support for SR300 camera formats.                
2. Tables used in the documentation were reformatted to preserve
line width

