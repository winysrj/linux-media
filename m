Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:44666 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3H0Ju1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 05:50:27 -0400
Received: from [10.61.81.153] (ams3-vpn-dhcp4506.cisco.com [10.61.81.153])
	(authenticated bits=0)
	by ams-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id r7R9oNju003461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 09:50:24 GMT
Message-ID: <521C765F.8010508@cisco.com>
Date: Tue, 27 Aug 2013 11:50:23 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.11] cx88 regression fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Here is a fix for a cx88 regression introduced in 3.10.

Regards,

	Hans

The following changes since commit 43054ecced8ae77c805470447d72da4fdc276e02:

  [media] davinci: vpif_capture: fix error return code in vpif_probe() (2013-08-26 07:54:47 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cx88fix

for you to fetch changes up to b9a1dfd3ba3ae00b0c1d1a396ed43fac85a32990:

  cx88: Fix regression: CX88_AUDIO_WM8775 can't be 0. (2013-08-27 11:49:36 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      cx88: Fix regression: CX88_AUDIO_WM8775 can't be 0.

 drivers/media/pci/cx88/cx88.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
