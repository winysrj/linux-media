Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54189 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547Ab1EEKNu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 06:13:50 -0400
References: <4DC2207B.5030700@redhat.com>
In-Reply-To: <4DC2207B.5030700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Patches still pending at linux-media queue (18 patches)
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 05 May 2011 06:13:44 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>, tomekbu@op.pl,
	Steven Stoth <stoth@kernellabs.com>,
	Jonathan Corbet <corbet@lwn.net>,
	=?ISO-8859-1?Q?Hern=E1n_Ordiales?= <h.ordiales@gmail.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Igor M. Liplianin" <liplianin@me.by>
Message-ID: <c3c9cb1f-6198-440a-956f-11d07c3f4504@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Mauro,

Since the original cx18 mmap() patch was commited, the cx18 mmap() cleanup patch is definitely needed: the YUV stream can lose frame alignment without it.

I took a quick look at the cx18 mmap() cleanup patch:

Acked-by: Andy Walls <awalls@md.metrocast.net>

The cx18 version bump patch is trivial:

Acked-by: Andy Walls <awalls@md.metrocast.net>

-Andy  
