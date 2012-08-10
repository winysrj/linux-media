Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:48635 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2HJNrd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 09:47:33 -0400
From: Konke Radlow <koradlow@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [PATCHv2 0/2] Add support for RDS decoding 
Date: Fri, 10 Aug 2012 15:46:24 +0000
Message-Id: <1344613586-21788-1-git-send-email-koradlow@gmail.com>
In-Reply-To: <[PATCH 0/2] Add support for RDS decoding>
References: <[PATCH 0/2] Add support for RDS decoding>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
after the positive feedback from the last RFC session, here now a patch
including all minor changes that were proposed.            

embarrassingly, I missed a minor bug introduced by removing the version 
field from the v4l2_rds struct, hence the resend
 
Regards,
Konke

