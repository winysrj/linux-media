Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758288Ab0E1UCU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 16:02:20 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4SK2JqI002997
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 28 May 2010 16:02:20 -0400
Date: Fri, 28 May 2010 16:02:18 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] IR: add Windows MCE/eHome IR receiver driver
Message-ID: <20100528200218.GA7313@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pair of patches adds ir-core support for the Windows Media Center
Edition / eHome Infrared Remote transceiver devices bundled with many
video capture cards, some HTPCs and various stand-alone kit.

[PATCH 1/2] IR: add RC6 keymap for Windows Media Center Ed. remotes
[PATCH 2/2] IR: add mceusb IR receiver driver

-- 
Jarod Wilson
jarod@redhat.com

