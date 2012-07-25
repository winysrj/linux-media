Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:12836 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab2GYPzJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 11:55:09 -0400
From: Konke Radlow <kradlow@cisco.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [RFC PATCH 0/2] Add support for RDS decoding 
Date: Wed, 25 Jul 2012 17:43:59 +0000
Message-Id: <1343238241-26772-1-git-send-email-kradlow@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Over the last couple of weeks I have been working on a library that adds
RDS decoding support to the v4l-utils repository. It currently supports
the core RDS standard but no advanced features yet like ODA (TMC).

I also wrote a control application that can be used to test the library
with any RDS-capable v4l device. This application is based on the v4l2-ctl
tool and many of the basic options have been taken over to ease the usage.

By default the tool will print all RDS fields that it was able to decode to the
std output.

The latest version of the code can always be found in my github repository:
https://github.com/koradlow/v4l2-rds-ctl

You can also find a tool that was created to generate test RDS data with 
the pcimax-3000+ card under Linux there. This program is functional,
but still a early version, and the functionality will be improved in the 
future: https://github.com/koradlow/pcimax-ctl

Upcoming:
TMC support (Traffic Message Channel)

This work is being done as part of a summerjob I`m doing at Cisco Systems
Norway with Hans Verkuil as my mentor.

Comments and remarks are very welcome.

Regards,
Konke 

