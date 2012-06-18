Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61427 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab2FRVAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 17:00:53 -0400
Received: by obbtb18 with SMTP id tb18so8994277obb.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 14:00:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120618205629.GI13539@mwanda>
References: <CALF0-+XS6gjiLDSGwumBp1xfXYvzii9f_Lw4qhyxVzwMzfh9Rg@mail.gmail.com>
	<20120618205629.GI13539@mwanda>
Date: Mon, 18 Jun 2012 18:00:52 -0300
Message-ID: <CALF0-+WX+cbF1s4vUBE0Fa6AMA3QcBwp7Bd1i=0rofZp7F_VAA@mail.gmail.com>
Subject: Re: [PATCH 0/12] struct i2c_algo_bit_data cleanup on several drivers
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
	stoth@kernellabs.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 18, 2012 at 5:56 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Mon, Jun 18, 2012 at 04:23:14PM -0300, Ezequiel Garcia wrote:
>> Hi Mauro,
>>
>> This patchset cleans the i2c part of some drivers.
>> This issue was recently reported by Dan Carpenter [1],
>> and revealed wrong (and harmless) usage of struct i2c_algo_bit.
>>
>
> How is this harmless?  We are setting the function pointers to
> something completely bogus.  It seems like a bad thing.
>

You're right, but that wrongly assigned struct  algo_bit_data is never
*ever* used,
since it is not registered.

So, I meant it was harmless in that way, perhaps it wasn't the right term.

Of course, I can be wrong.
Ezequiel.
