Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:65289 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269Ab2HJPGH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 11:06:07 -0400
From: Konke Radlow <koradlow@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [RFC PATCH 0/1] Adding core TMC decoding support to RDS library
Date: Fri, 10 Aug 2012 17:04:51 +0000
Message-Id: <1344618292-24776-1-git-send-email-koradlow@gmail.com>
In-Reply-To: <[PATCHv2 0/2] Add support for RDS decoding>
References: <[PATCHv2 0/2] Add support for RDS decoding>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
this patch adds the core of TMC decoding support to the RDS library.
Single and multigroup TMC messages as well as TMC system messages
are decoded into an easily accessable format and can be used as the 
basis for a complete TMC decoding implementation.

The part that's missing from the code are the extensive lookup-tables that
necessary to decode the dictionary-based TMC protocol into a human readable
representation. 

As these LUTs are just the next layer in TMC decoding and don't add a lot of
complexity or logic to the code it was decided to release an [RFC PATCH] at 
the current state, so that it might be merged into the master branch together
with the RDS-decoding library.

Regards,
Konke

