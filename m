Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:58498 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab1KDIY5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 04:24:57 -0400
Received: from xbh-ams-201.cisco.com (xbh-ams-201.cisco.com [144.254.75.7])
	by ams-core-4.cisco.com (8.14.3/8.14.3) with ESMTP id pA48FH7h021765
	for <linux-media@vger.kernel.org>; Fri, 4 Nov 2011 08:15:17 GMT
Message-ID: <4EB39F9F.9080305@cisco.com>
Date: Fri, 04 Nov 2011 09:17:35 +0100
From: Mats Randgaard <mats.randgaard@cisco.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: V4L2_IN_ST_NO_SYNC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
VIDIOC_ENUMINPUT may set the flag V4L2_IN_ST_NO_SYNC in the status 
field. The flag is described in the documentation under "Digital Video" 
as "No synchronization lock" 
(http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-enuminput). What 
kind of sync lock does it refer to? Horizontal sync lock? Vertical sync 
lock? Both? Tuner locked on signal? Something else? A few lines above is 
V4L2_IN_ST_NO_H_LOCK described under "Analog Video" as "No horizontal 
sync lock". Is V4L2_IN_ST_NO_SYNC the same as V4L2_IN_ST_NO_H_LOCK, but 
for digital video? Anyone who knows?

Regards,
         Mats Randgaard
