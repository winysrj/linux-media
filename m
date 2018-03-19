Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35218 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755339AbeCSHPL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 03:15:11 -0400
Date: Mon, 19 Mar 2018 10:14:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ji-Hun Kim <ji_hun.kim@samsung.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        arvind.yadav.cs@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: Re: [PATCH] staging: media: davinci_vpfe: add error handling on
 kmalloc failure
Message-ID: <20180319071435.svpg72uomxfc6hoj@mwanda>
References: <CGME20180316045841epcas2p34dc11231c65e2032e88ac7138db2daee@epcas2p3.samsung.com>
 <1521176303-17546-1-git-send-email-ji_hun.kim@samsung.com>
 <20180316083234.yq7a4rx6w35amflu@mwanda>
 <20180319042457.GB2915@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180319042457.GB2915@ubuntu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 19, 2018 at 01:24:57PM +0900, Ji-Hun Kim wrote:
> >   1294                          } else if (to && !from && size) {
> >   1295                                  rval = module_if->set(ipipe, NULL);
> >   1296                                  if (rval)
> >   1297                                          goto error;
> > 
> > And here again goto free_params.
> > 
> >   1298                          }
> >   1299                          kfree(params);
> >   1300                  }
> >   1301          }
> >   1302  error:
> >   1303          return rval;
> > 
> > 
> > Change this to:
> > 
> > 	return 0;
> Instead of returning rval, returning 0 would be fine? It looks that should
> return rval in normal case.
> 

In the proposed code, the errors all do a return or a goto so "rval"
would be zero here.  Then the error path would look like:

err_free_params:
	kfree(params);
	return rval;
}

regards,
dan carpenter
