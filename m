Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55163
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752129AbdHBSdA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 14:33:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by osg.samsung.com (Postfix) with ESMTP id 996E2A0CAD
        for <linux-media@vger.kernel.org>; Wed,  2 Aug 2017 18:33:28 +0000 (UTC)
Received: from osg.samsung.com ([127.0.0.1])
        by localhost (s-opensource.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CdYofnGsFNkM for <linux-media@vger.kernel.org>;
        Wed,  2 Aug 2017 18:33:28 +0000 (UTC)
Received: from hank.sisa.samsung.com (unknown [162.246.216.202])
        by osg.samsung.com (Postfix) with ESMTPSA id 0D74FA0C9D
        for <linux-media@vger.kernel.org>; Wed,  2 Aug 2017 18:33:28 +0000 (UTC)
From: "Reynaldo H. Verdejo Pinochet" <reynaldo@osg.samsung.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2][dtv-scan-tables] Add new tables for San Jose and Mountain View, California
Date: Wed,  2 Aug 2017 11:32:48 -0700
Message-Id: <20170802183250.9553-1-reynaldo@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following two patches add city-specific initial scan tables for San Jose and Mountain view. I tried these personally with good results. Particularly in MV with 73 channels output by dvbv5-scan.

Bests,

--
Reynaldo H. Verdejo Pinochet
OSG, Samsung Research America
 
