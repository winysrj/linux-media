Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35967 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdJGNwI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Oct 2017 09:52:08 -0400
From: Srishti Sharma <srishtishar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: media: atomisp: pci: Eliminate use of typedefs for struct
Date: Sat,  7 Oct 2017 19:22:02 +0530
Message-Id: <1507384322-16584-1-git-send-email-srishtishar@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The use of typedefs for struct is discouraged, and hence can be
eliminated. Done using the following semantic patch by coccinelle.

@r1@
type T;
@@

typedef struct {...} T;

@script: python p@
T << r1.T;
T1;
@@

if T[-2:] == "_t" or T[-2:] == "_T":
        coccinelle.T1 = T[:-2]
else:
        coccinelle.T1 = T

print T, T1
@r2@
type r1.T;
identifier p.T1;
@@

- typedef
struct
+ T1
{
...
}
- T
;

@r3@
type r1.T;
identifier p.T1;
@@

- T
+ struct T1

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
 .../media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c  | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
index d9178e8..6d9bceb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/spctrl/src/spctrl.c
@@ -37,7 +37,7 @@ more details.
 #include "ia_css_spctrl.h"
 #include "ia_css_debug.h"
 
-typedef struct {
+struct spctrl_context_info {
 	struct ia_css_sp_init_dmem_cfg dmem_config;
 	uint32_t        spctrl_config_dmem_addr; /** location of dmem_cfg  in SP dmem */
 	uint32_t        spctrl_state_dmem_addr;
@@ -45,9 +45,9 @@ typedef struct {
 	hrt_vaddress    code_addr;          /* sp firmware location in host mem-DDR*/
 	uint32_t        code_size;
 	char           *program_name;       /* used in case of PLATFORM_SIM */
-} spctrl_context_info;
+};
 
-static spctrl_context_info spctrl_cofig_info[N_SP_ID];
+static struct spctrl_context_info spctrl_cofig_info[N_SP_ID];
 static bool spctrl_loaded[N_SP_ID] = {0};
 
 /* Load firmware */
-- 
2.7.4
