Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:35139 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbLaNqX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2015 08:46:23 -0500
Received: by mail-qg0-f49.google.com with SMTP id o11so201596679qge.2
        for <linux-media@vger.kernel.org>; Thu, 31 Dec 2015 05:46:23 -0800 (PST)
MIME-Version: 1.0
From: Mike Martin <mike@redtux.org.uk>
Date: Thu, 31 Dec 2015 13:45:43 +0000
Message-ID: <CAOwYNKZU-eb+hCzMWiBf+TNoCfTzepLn1aMiivaPNZV0qxOWUA@mail.gmail.com>
Subject: Questions about dvbv5-scan (missing fields)
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
I hope this is the right list to ask.

I am looking at using dvbv5 for one of my projects. However there are
some fields that I cant seem to get, in particular

tsid
pmt
service_type (TV?Radio etc)
net
netid
example output in VDR format

CBS Drama:538000:S0B8C34D12I1M64T8G32Y0:T:27500:0:0:0:0:14640:0:0:0:
Showcase TV:538000:S0B8C34D12I1M64T8G32Y0:T:27500:0:0:0:0:15296:0:0:0:
Box Nation:538000:S0B8C34D12I1M64T8G32Y0:T:27500:0:0:0:0:14416:0:0:0:
Horror Channel:538000:S0B8C34D12I1M64T8G32Y0:T:27500:6129:6130,6131:0:0:14480:0:0:0:
365 Travel:538000:S0B8C34D12I1M64T8G32Y0:T:27500:0:0:0:0:14784:0:0:0:
Television X:538000:S0B8C34D12I1M64T8G32Y0:T:27500:0:0:0:0:15232:0:0:0:
5 USA:538000:S0B8C34D12I1M64T8G32Y0:T:27500:6689:6690,6691:0:0:12992:0:0:0:
5*:538000:S0B8C34D12I1M64T8G32Y0:T:27500:6673:6674,6675:0:0:12928:0:0:0:
QUEST:538000:S0B8C34D12I1M64T8G32Y0:T:27500:6929:6930,6931:0:0:14498:0:0:0:

A can be seen there is loads of zeros where entries should be

thanks
