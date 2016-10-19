Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48313
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936174AbcJSVI1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 17:08:27 -0400
Date: Wed, 19 Oct 2016 19:08:22 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jean-Baptiste Abbadie <jb@abbadie.fr>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: media: radio-bcm2048: Remove FSF address
 from GPL notice
Message-ID: <20161019190822.39da3a46@vento.lan>
In-Reply-To: <20161019204714.11645-4-jb@abbadie.fr>
References: <20161019204714.11645-1-jb@abbadie.fr>
        <20161019204714.11645-4-jb@abbadie.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Oct 2016 22:47:14 +0200
Jean-Baptiste Abbadie <jb@abbadie.fr> escreveu:

> Removes the superfluous statement about writing to the FSF in the GPL
> notice

Looks OK to me. Greg, do you want to pick it on your tree or do you
prefer if I pick myself?

If you prefer to pick it:

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

> 
> Signed-off-by: Jean-Baptiste Abbadie <jb@abbadie.fr>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index f66bea631e8e..607dd5285149 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -17,10 +17,6 @@
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>   * General Public License for more details.
>   *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> - * 02110-1301 USA
>   */
>  
>  /*



Thanks,
Mauro
