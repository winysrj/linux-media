Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:60229 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303AbZJaXNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:13:14 -0400
Message-ID: <4AECC486.7080404@freemail.hu>
Date: Sun, 01 Nov 2009 00:13:10 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 00/21] gspca pac7302/pac7311: separate the two drivers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the following patchset refactores the Pixart PAC7311 subdriver. The
current situation is that the code contains a lot of decisions
like this:

    if (sd->sensor == SENSOR_PAC7302) {
        ... do this ...
    } else {
        ... do something else ...
    }

The sensor type is determined using the USB Vendor ID and Product
ID which means that the decisions shown are not really necessary.

The goal of the patchset is to have a PAC7302 and a PAC7311 subdriver
which have the benefit that there is no decision necessary on sensor
type at runtime. The common functions can be extracted later but this
would be a different patchset.

Regards,

	Márton Németh

