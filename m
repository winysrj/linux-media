Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2393 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3JGHlt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Oct 2013 03:41:49 -0400
Message-ID: <5252647F.40706@xs4all.nl>
Date: Mon, 07 Oct 2013 09:36:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>, js@linuxtv.org
Subject: Patchwork down?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Opening https://patchwork.linuxtv.org/ gives me:

OperationalError at /

(2002, "Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (111)")

Request Method: 	GET
Request URL: 	https://patchwork.linuxtv.org/
Django Version: 	1.2.3
Exception Type: 	OperationalError
Exception Value: 	

(2002, "Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (111)")

Exception Location: 	/usr/lib/pymodules/python2.6/MySQLdb/connections.py in __init__, line 170
Python Executable: 	/usr/bin/python
Python Version: 	2.6.6
Python Path: 	['/usr/local/patchwork/apps', '/usr/local/patchwork', '/usr/local/patchwork/lib/python', '/usr/lib/python2.6', '/usr/lib/python2.6/plat-linux2', '/usr/lib/python2.6/lib-tk', '/usr/lib/python2.6/lib-old', '/usr/lib/python2.6/lib-dynload', '/usr/local/lib/python2.6/dist-packages', '/usr/lib/python2.6/dist-packages', '/usr/lib/pymodules/python2.6']
Server time: 	Mon, 7 Oct 2013 09:36:20 +0200

Regards,

	Hans
