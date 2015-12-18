Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38994 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbbLRIEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 03:04:38 -0500
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Preliminary HDCP code available in my tree
Cc: mkhelik@cisco.com
Message-ID: <5673BE11.7040702@xs4all.nl>
Date: Fri, 18 Dec 2015 09:04:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Two years ago Cisco did some work on HDCP support for HDMI receivers and transmitters,
but for one reason or another that work was never put into actual use. Rather than
letting that work go unnoticed I decided to put it up in my git tree:

http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=hdcp

It's missing documentation, it's tested with HDCP 1.4 only (not 2.2), and it needs some
TLC, but it was working at the time. So this could be a good starting point for someone.

If someone decides to work on this, please contact me first.

Regards,

	Hans
