Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62142 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762049Ab0GUDGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 23:06:06 -0400
Received: by iwn7 with SMTP id 7so6379825iwn.19
        for <linux-media@vger.kernel.org>; Tue, 20 Jul 2010 20:06:04 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 21 Jul 2010 11:06:02 +0800
Message-ID: <AANLkTilMPncmtk5OC4pe2Mbi-3bTmp3dxZM2JB5p5u-o@mail.gmail.com>
Subject: Is it feasible to add another driver for CCIC?
From: Jun Nie <niej0001@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
    I am working on CCIC camera controller driver and want to push it
into kernel. This CCIC IP is similar with IP of cafe_ccic, but with
lots of change: no I2C bus, embedded in SOC/no PCI, support both
parallel and CSI interface. So some register definition changes.
    I just want to confirm that a new driver for SOC CCIC is
acceptable for community.
    Thanks!

Jun
