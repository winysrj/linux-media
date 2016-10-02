Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33477 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbcJBAGg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2016 20:06:36 -0400
Received: by mail-pf0-f195.google.com with SMTP id i85so100280pfa.0
        for <linux-media@vger.kernel.org>; Sat, 01 Oct 2016 17:06:30 -0700 (PDT)
Date: Sat, 1 Oct 2016 17:06:27 -0700
From: Wayne Porter <wporter82@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] [media] bcm2048: Remove FSF mailing address
Message-ID: <20161002000627.3dkhou6dq2by7hgq@Chronos>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lwqy5ygj5v4ekdzc"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lwqy5ygj5v4ekdzc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

FSF address changes, checkpatch recommends removing it

Signed-off-by: Wayne Porter <wporter82@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.h b/drivers/stagin=
g/media/bcm2048/radio-bcm2048.h
index 4c90a32..4d950c1 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.h
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.h
@@ -14,11 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
  */
=20
 #ifndef BCM2048_H
--=20
2.9.3


--lwqy5ygj5v4ekdzc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJX8E97AAoJEMcDZgYHTWDOGw0H/RfCgWnA9Oo3mVl6VAhZHeeU
mt44oyDyevhMfdAh5LxyH/Yy5/75fmuXkqmuIFlzv19cP6/ow2MCJg1s5XGNyzIr
n3FKpkymsrGudEQl85P7q7hiB0Co/TnftJ5WF1/zkOcD8Gs2/M1uqpcwv/OkNPbE
ddxKSsAJTHGAS3NUu9hOJjf/Vr/e1zDdHBrTsUTfvYmR+sFg1sy3xVA4xBl15W1I
jhNmpb2UXWenfDgbX00kYlskxJkEJ8+OvqXzwU/tuSQ4iWm+vUpOixmvC74d/aAw
BZ7KWHquSenW77itaSvA5RHOJPI3Z/A1P5K9xN7+sgdTpMp97wddGaNfx9VrWyQ=
=cPUt
-----END PGP SIGNATURE-----

--lwqy5ygj5v4ekdzc--
