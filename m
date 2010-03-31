Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54117 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab0CaLkF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 07:40:05 -0400
Subject: Re: CX23102 (Polaris?)
From: Andy Walls <awalls@radix.net>
To: Rich <rich.kcsa@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <6d1fd7691003302150n4e56ea40y9b58285994ab2bdd@mail.gmail.com>
References: <6d1fd7691003302150n4e56ea40y9b58285994ab2bdd@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 31 Mar 2010 07:40:00 -0400
Message-Id: <1270035601.3937.12.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-03-30 at 22:50 -0600, Rich wrote:
> I have a ez grabber with a CX23102 windows calls it Polaris. Ubuntu
> 9.10 does not find it.  Is  there a driver for this part?

Rich,

(Be advised, I generally don't respond to personal emails on linux
driver issues.  I prefer to keep conversations public, so I'm Cc:-ing
the linux-media list.)


1. Yes, there is a driver: the cx231xx module with the cx25840 module as
a major supporting module.

2. The cx231xx module only has card definitions for a couple of Conexant
reference designs.  Defintions to support your board would need to be
added to the driver before it would work.

3. Looking at the cx231xx code paths in the cx25840 module, I suspect
that module may need some tweaking too. 


4. If you need support for this board, and you don't want to make the
patches yourself, please build a page at the V4L-DVB wiki, and provide 

a. USB ID information
b. A list of chips on the board
c. pictures of both sides of the board if you can.

Also you will most likely need to get a board in the hands of developer
who has time.

Regards,
Andy


