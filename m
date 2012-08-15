Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57550 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2HOObL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 10:31:11 -0400
Received: by wgbdr13 with SMTP id dr13so1438283wgb.1
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 07:31:10 -0700 (PDT)
From: Konke Radlow <koradlow@googlemail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [RFC PATCHv2 0/1] Adding core TMC decoding support to RDS library
Date: Wed, 15 Aug 2012 16:30:57 +0200
Message-Id: <1345041058-1334-1-git-send-email-koradlow@gmail.com>
In-Reply-To: <[RFC PATCH 0/1] Adding core TMC decoding support to RDS library>
References: <[RFC PATCH 0/1] Adding core TMC decoding support to RDS library>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

this patch is an updated version of the last RDS-TMC core support patch. 

The changes proposed by Hans Verkuil were implemented. In addition
the handling and decoding of multi-group TMC messages was heavily modified,
in order to improve read- and maintainability

Regards,
Konke


