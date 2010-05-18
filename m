Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57775 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab0ERFDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 01:03:52 -0400
Received: by iwn6 with SMTP id 6so1172311iwn.19
        for <linux-media@vger.kernel.org>; Mon, 17 May 2010 22:03:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilcusOnh6VdNR5Rvkd1wvSPLb2D7-EX5Ryy-LVz@mail.gmail.com>
References: <AANLkTilcusOnh6VdNR5Rvkd1wvSPLb2D7-EX5Ryy-LVz@mail.gmail.com>
Date: Tue, 18 May 2010 02:03:51 -0300
Message-ID: <AANLkTimKPmqQiIP32b8lc2EFFmqckcPBbvWYQV8--Oge@mail.gmail.com>
Subject: Re: 2.6.29 additional build errors
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: =?ISO-8859-2?Q?Samuel_Rakitni=E8an?= <samuel.rakitnican@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Samuel,

2010/5/15 Samuel Rakitničan <samuel.rakitnican@gmail.com>:
> Additional build errors found after disabling the non building modules
> on todays mercurial tree.

Please update your local repository:

$ hg pull -u
$ make distclean
$ make

Now should work.

Thanks for your report.

Cheers
Douglas
