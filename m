Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37559 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3IOC2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Sep 2013 22:28:49 -0400
Received: by mail-pd0-f169.google.com with SMTP id r10so2782967pdi.0
        for <linux-media@vger.kernel.org>; Sat, 14 Sep 2013 19:28:49 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Roberto_Alc=E2ntara?= <roberto@eletronica.org>
Date: Sat, 14 Sep 2013 23:28:28 -0300
Message-ID: <CAEt6MXmptWRCJpAocNQMYH47N35bNP3nki5UsZGwSQb=cdUdNw@mail.gmail.com>
Subject: Siano - Device presence handler
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guys,

Looking Siano driver files I can find lot of "container_of" macro as in
smdvb.main smsdvb_read_signal_strength :

client = container_of(fe, struct smsdvb_client_t, frontend);

But I can't find any error checking before client use.

Something like

if (!client) {
  return NODEV;
}

before client access should not be useful to avoid error condition ?

Thank you,

 - Roberto
