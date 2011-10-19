Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab1JSUWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 16:22:04 -0400
Received: from hpaq1.eem.corp.google.com (hpaq1.eem.corp.google.com [172.25.149.1])
	by smtp-out.google.com with ESMTP id p9JKM3v1029133
	for <linux-media@vger.kernel.org>; Wed, 19 Oct 2011 13:22:03 -0700
Received: from pzk4 (pzk4.prod.google.com [10.243.19.132])
	by hpaq1.eem.corp.google.com with ESMTP id p9JKHX4s026975
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-media@vger.kernel.org>; Wed, 19 Oct 2011 13:22:01 -0700
Received: by pzk4 with SMTP id 4so6496765pzk.10
        for <linux-media@vger.kernel.org>; Wed, 19 Oct 2011 13:22:00 -0700 (PDT)
Date: Wed, 19 Oct 2011 13:21:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Antonio Ospite <ospite@studenti.unina.it>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
cc: "Tomas M." <tmezzadra@gmail.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: kernel OOPS when releasing usb webcam (random)
In-Reply-To: <alpine.DEB.2.00.1110181332320.2639@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1110191321200.2892@chino.kir.corp.google.com>
References: <4E9CB0C2.3030902@gmail.com> <alpine.DEB.2.00.1110171703210.13515@chino.kir.corp.google.com> <20111018104054.07aa2bcf462c0268a23c0139@studenti.unina.it> <alpine.DEB.2.00.1110181332320.2639@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 Oct 2011, David Rientjes wrote:

> Guennadi or Mauro, how is this going to Linus?  It sounds like 3.1 
> material since we've received at least a couple of reports of this in the 
> past week.
> 

This fix is now in Linus' tree at e58fced201ad ("[media] videodev: fix a 
NULL pointer dereference in v4l2_device_release()") for 3.1.
