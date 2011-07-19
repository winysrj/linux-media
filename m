Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1GSMP1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 08:15:27 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6JCFQhj026579
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 08:15:27 -0400
Received: from shalem.localdomain (vpn1-6-8.ams2.redhat.com [10.36.6.8])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p6JCFOu3026346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 08:15:26 -0400
Message-ID: <4E2575B7.3080306@redhat.com>
Date: Tue, 19 Jul 2011 14:16:55 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC: removing pwc kconfig options
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The pwc driver currently has 2 kconfig options, one to enable /
disable various debugging options, and another for enabling/
disabling input-evdev support.

IMHO these both can go away, the debugging can trigger on
CONFIG_VIDEO_ADV_DEBUG, and the input on CONFIG_INPUT.

Regards,

Hans
