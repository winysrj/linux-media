Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1GSMMW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 08:12:22 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6JCCLhs029158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 08:12:22 -0400
Received: from shalem.localdomain (vpn1-6-8.ams2.redhat.com [10.36.6.8])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6JCCKnU008003
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 08:12:21 -0400
Message-ID: <4E2574FF.7040608@redhat.com>
Date: Tue, 19 Jul 2011 14:13:51 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC: removing a bunch of module options from the pwc driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

In the light of my ongoing pwc driver cleanup I would like to
remove a bunch of module options, like the device_hint option which
allows one the specify a preferred minor, which does not really
fit well in our modern dynamic minor v4l2 config, and there
are a bunch of options for things which should set through
the v4l2 API rather then through a module option, like fps.

I thought I would consult the list before ripping this out,
in case someone considers removing module options ABI breakage...

So any objections?

Regards,

Hans
