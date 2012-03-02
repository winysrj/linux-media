Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43735 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab2CBUjZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 15:39:25 -0500
Received: by iagz16 with SMTP id z16so2762115iag.19
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2012 12:39:25 -0800 (PST)
Date: Fri, 2 Mar 2012 14:39:13 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Jarod Wilson <jarod@redhat.com>,
	Torsten Crass <torsten.crass@eBiology.de>
Subject: [PATCH 3.0.y 0/4] Re: lirc_serial spuriously claims assigned port
 and irq to be in use
Message-ID: <20120302203913.GA22323@burratino>
References: <1321422581.2885.50.camel@deadeye>
 <20120302034545.GA31860@burratino>
 <1330662942.8460.229.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330662942.8460.229.camel@deadeye>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ben Hutchings wrote:
> On Thu, 2012-03-01 at 21:45 -0600, Jonathan Nieder wrote:

>> Would some of these patches (e.g., at least patches 1, 2, and 5) be
>> appropriate for inclusion in the 3.0.y and 3.2.y stable kernels from
>> kernel.org?
>
> Assuming they haven't caused any regressions, I think everything except
> 9b98d6067971 (4/5) would be appropriate.

Great.  Here are the aforementioned patches rebased against 3.0.y, in
the hope that some interested person can confirm they still work.  The
only backporting needed was to adjust to the lack of
drivers/staging/lirc -> drivers/staging/media/lirc renaming.

Ben Hutchings (4):
  [media] staging: lirc_serial: Fix init/exit order
  [media] staging: lirc_serial: Free resources on failure paths of
	lirc_serial_probe()
  [media] staging: lirc_serial: Fix deadlock on resume failure
  [media] staging: lirc_serial: Do not assume error codes returned by
	request_irq()

 drivers/staging/lirc/lirc_serial.c |  100 +++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 53 deletions(-)
