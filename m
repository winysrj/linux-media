Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50408 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab2DTLek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 07:34:40 -0400
Received: by qcro28 with SMTP id o28so5772572qcr.19
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2012 04:34:40 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 20 Apr 2012 12:34:40 +0100
Message-ID: <CAAMvbhFWno9ibo4Db9Xpdzwsv7+70evR8-ZydYc4RNQtPAD3-Q@mail.gmail.com>
Subject: CX23885 MSI
From: James Courtier-Dutton <james.dutton@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I noticed that the CX23885 driver does not set it up to use MSI.
I don't have the datasheets. Is there any know reason not to use MSI
with this PCI Express card?
I just want to know before I spend time enabling MSI for this device.
It is my understanding that MSI is generally preferred over previous
IRQ methods.

Kind Regards

James.
