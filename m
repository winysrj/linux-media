Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34527 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1G0Rly (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 13:41:54 -0400
Received: by wyg8 with SMTP id 8so1167015wyg.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 10:41:53 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Jul 2011 21:41:52 +0400
Message-ID: <CAD+npnoP-CBu2KvJ9qBKeyebtJKA-EUwrk4qcTbBPk-OxkWurw@mail.gmail.com>
Subject: [dvbscan] missing LNB type
From: Sergey Mironov <ierton@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi. I want to share experience in the field of using linuxtv-dvb-utils.
Dvbscan (that is scan.s from source tarball) has following LNB
parameters hardcoded:

 static struct lnb_types_st lnbs[] = {
     {"UNIVERSAL",   univ_desc,      9750, 10600, 11700 },
     {"DBS",     dbs_desc,       11250, 0, 0 },
     {"STANDARD",    standard_desc,      10000, 0, 0 },
     {"ENHANCED",    enhan_desc,     9750, 0, 0 },
     {"C-BAND",  cband_desc,     5150, 0, 0 }
 };

I wonder if these parameters are well-known standards and is it ok to
hide them from user. I think it is not.
We have a situation with our local providers (Moscow, Russia) like
TriColor or NTV+. It seems, they assume different frequency values for
'UIVERSAL' LNBs when broadcast network Information. Correct high_val
value is 10750, so whole lnb_type entry should be

  {"UNIVERSAL2",   univ_desc,      9750, 10750, 11700 }

I am not an expert in other software of this kind and will be happy to
know how others solve this problem. Meanwhile I've wrote another
utility to tune up my qpsk frontend, its name is tuneqpsk. Whole
project is located at github [1] - it is part of our company's board
support package.

Thanks, Sergey
PS. I am not in list, please CC me directly.

[1] - https://github.com/ierton/libmdemux
